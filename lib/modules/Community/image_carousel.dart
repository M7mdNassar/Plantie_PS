import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../shared/styles/app_colors.dart';
import 'image_view_screen.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ImageCarousel({super.key, required this.imageUrls});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  void _prefetchNearbyImages(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final nearbyIndexes = <int>{index - 1, index, index + 1}
          .where((i) => i >= 0 && i < widget.imageUrls.length);

      for (final i in nearbyIndexes) {
        precacheImage(CachedNetworkImageProvider(widget.imageUrls[i]), context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _prefetchNearbyImages(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ImageViewScreen(
                imageUrls: widget.imageUrls,
                initialIndex: _currentPage,
              ),
            ),
          ),
          child: SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  _prefetchNearbyImages(page);
                },
              itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        child: const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
