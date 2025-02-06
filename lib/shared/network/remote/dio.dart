import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        receiveTimeout: Duration(seconds: 5),
        sendTimeout: Duration(seconds: 5),
      ),
    );
  }

  // Download image using Dio
  static Future downloadImage(String imageUrl) async {
    try {
      Response response = await dio.get(imageUrl,
          options: Options(responseType: ResponseType.bytes));
      return response.data;
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }

  // Upload image to Firebase Storage
// Upload image to Firebase Storage
  static Future<String> uploadImageToFirebase(
      imageBytes, String storagePath) async {
    try {
      // Generate a unique file name
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Firebase Storage reference with dynamic storage path
      Reference storageRef =
          FirebaseStorage.instance.ref().child("$storagePath$fileName");

      // Upload the image to Firebase Storage
      await storageRef.putData(imageBytes);

      // Get the download URL
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Combine download and upload functionality
  static Future<String> downloadAndUploadImage(String imageUrl) async {
    try {
      // Download the image
      var imageBytes = await downloadImage(imageUrl);

      // Upload the image and get the URL
      return await uploadImageToFirebase(imageBytes, "profiles/");
    } catch (e) {
      throw Exception('Failed to download and upload image: $e');
    }
  }
}
