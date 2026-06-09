import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageStorageHelper {
  static Future<File> saveImagePermanently(File originalImage) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${directory.path}/$fileName';

      // Check if source file exists
      if (!await originalImage.exists()) {
        throw Exception('Original image file not found');
      }

      final savedFile = await originalImage.copy(newPath);

      // Verify the copy was successful
      if (!await savedFile.exists()) {
        throw Exception('Failed to save image permanently');
      }

      return savedFile;
    } catch (e) {
      log('Error saving image: $e');
      rethrow;
    }
  }

  static Future<void> deleteImageFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      log('Error deleting image: $e');
      rethrow;
    }
  }
}
