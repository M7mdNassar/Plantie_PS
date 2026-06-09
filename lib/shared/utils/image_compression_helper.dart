import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Helper class for image compression and optimization
class ImageCompressionHelper {
  /// Compress image file before upload
  ///
  /// [imageFile] - The image file to compress
  /// [quality] - JPEG quality (0-100), default 75
  /// [maxWidth] - Maximum width in pixels, useful for limiting large images
  /// [maxHeight] - Maximum height in pixels
  ///
  /// Returns compressed image bytes
  static Future<Uint8List> compressImage({
    required File imageFile,
    int quality = 75,
    int? maxWidth = 1920,
    int? maxHeight = 1920,
  }) async {
    try {
      // Read image bytes
      final bytes = await imageFile.readAsBytes();

      // Decode image
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize if needed
      img.Image resizedImage = image;
      if (maxWidth != null && maxHeight != null) {
        if (image.width > maxWidth || image.height > maxHeight) {
          resizedImage = img.copyResize(
            image,
            width: maxWidth,
            height: maxHeight,
            interpolation: img.Interpolation.average,
          );
        }
      }

      // Encode as JPEG with quality setting
      final Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: quality),
      );

      return compressedBytes;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      // Return original bytes if compression fails
      return await imageFile.readAsBytes();
    }
  }

  /// Get compression statistics
  static Future<CompressionStats> getCompressionStats({
    required File originalFile,
    required Uint8List compressedBytes,
  }) async {
    final originalSize = await originalFile.length();
    final compressedSize = compressedBytes.length;
    final reductionPercent = ((originalSize - compressedSize) / originalSize) * 100;

    return CompressionStats(
      originalSizeKB: originalSize / 1024,
      compressedSizeKB: compressedSize / 1024,
      reductionPercent: reductionPercent,
    );
  }

  /// Save compressed image to temporary file
  static Future<File> saveCompressedImage(Uint8List bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/compressed_$timestamp.jpg');

      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Error saving compressed image: $e');
      rethrow;
    }
  }

  /// Batch compress multiple images
  static Future<List<Uint8List>> compressImages({
    required List<File> imageFiles,
    int quality = 75,
    int? maxWidth = 1920,
    int? maxHeight = 1920,
  }) async {
    final List<Uint8List> compressedImages = [];

    for (final imageFile in imageFiles) {
      try {
        final compressed = await compressImage(
          imageFile: imageFile,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
        compressedImages.add(compressed);
      } catch (e) {
        debugPrint('Error compressing image $imageFile: $e');
      }
    }

    return compressedImages;
  }
}

/// Data class for compression statistics
class CompressionStats {
  final double originalSizeKB;
  final double compressedSizeKB;
  final double reductionPercent;

  CompressionStats({
    required this.originalSizeKB,
    required this.compressedSizeKB,
    required this.reductionPercent,
  });

  @override
  String toString() {
    return 'CompressionStats('
        'Original: ${originalSizeKB.toStringAsFixed(2)}KB, '
        'Compressed: ${compressedSizeKB.toStringAsFixed(2)}KB, '
        'Reduction: ${reductionPercent.toStringAsFixed(1)}%)';
  }
}

