import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';
import 'package:plantie/shared/services/error_handler.dart';
class DioHelper {
  static late Dio dio;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);

  static void init() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptors for logging and error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Log network errors
          debugLogNetworkError(error);
          return handler.next(error);
        },
      ),
    );
  }

  /// Download image using Dio with retry logic
  static Future<Uint8List> downloadImage(
    String imageUrl, {
    int retryCount = 0,
  }) async {
    try {
      Response response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data as Uint8List;
    } catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        return downloadImage(imageUrl, retryCount: retryCount + 1);
      }

      final networkException = ErrorHandler.handleNetworkError(e, notify: false);
      throw networkException;
    }
  }

  /// Upload image to Supabase Storage with retry logic
  static Future<String> uploadImageToSupabase(
    Uint8List imageBytes,
    String storagePath, {
    int retryCount = 0,
  }) async {
    try {
      // Generate a unique file name
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image to Supabase Storage
      return await supabaseService.uploadFile(
        bucket: 'user-avatars',
        path: storagePath,
        fileBytes: imageBytes,
        fileName: fileName,
      );
    } catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        return uploadImageToSupabase(
          imageBytes,
          storagePath,
          retryCount: retryCount + 1,
        );
      }

      final networkException = ErrorHandler.handleNetworkError(e, notify: false);
      throw networkException;
    }
  }

  /// Combine download and upload functionality with retry logic
  static Future<String> downloadAndUploadImage(
    String imageUrl, {
    int retryCount = 0,
  }) async {
    try {
      // Download the image
      var imageBytes = await downloadImage(imageUrl);

      // Upload the image and get the URL
      return await uploadImageToSupabase(imageBytes, "profiles/");
    } catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        return downloadAndUploadImage(imageUrl, retryCount: retryCount + 1);
      }
      rethrow;
    }
  }

  /// Check if error is retryable
  static bool _shouldRetry(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionError:
          return true;
        case DioExceptionType.badResponse:
          // Retry on 5xx errors only
          final statusCode = error.response?.statusCode;
          return statusCode != null && statusCode >= 500;
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
          return false;
      }
    }
    return false;
  }

  /// Debug log network errors
  static void debugLogNetworkError(DioException error) {
    String errorMessage = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Bad response: ${error.response?.statusCode}';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Unknown error';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
    }

    debugPrint('🌐 Dio Error: $errorMessage');
  }
}

void debugPrint(String message) {
  print(message);
}


