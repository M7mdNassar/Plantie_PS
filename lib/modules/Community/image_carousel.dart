import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) => CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                fit: BoxFit.cover,
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
                    ? plantieColor
                    : Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
