import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late final PageController _pageController;

  void _prefetchAdjacent(int index) {
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
    _pageController = PageController(initialPage: widget.initialIndex);
    _prefetchAdjacent(widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrls[index],
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.broken_image_outlined, color: Colors.white70),
              ),
            ),
          );
        },
        onPageChanged: _prefetchAdjacent,
      ),
    );
  }
}
