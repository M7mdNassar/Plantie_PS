/// Base exception class for all app-level exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  final int? statusCode;

  NetworkException({
    required String message,
    this.statusCode,
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
    stackTrace: stackTrace,
  );

  factory NetworkException.noInternet() => NetworkException(
    message: 'No internet connection. Please check your network and try again.',
    code: 'NO_INTERNET',
  );

  factory NetworkException.timeout() => NetworkException(
    message: 'Request timed out. Please try again.',
    code: 'TIMEOUT',
  );

  factory NetworkException.serverError(int statusCode) => NetworkException(
    message: 'Server error (${statusCode}). Please try again later.',
    statusCode: statusCode,
    code: 'SERVER_ERROR',
  );

  factory NetworkException.badRequest() => NetworkException(
    message: 'Invalid request. Please check your input and try again.',
    statusCode: 400,
    code: 'BAD_REQUEST',
  );

  factory NetworkException.unauthorized() => NetworkException(
    message: 'Unauthorized. Please log in again.',
    statusCode: 401,
    code: 'UNAUTHORIZED',
  );

  factory NetworkException.forbidden() => NetworkException(
    message: 'Access denied. You do not have permission.',
    statusCode: 403,
    code: 'FORBIDDEN',
  );

  factory NetworkException.notFound() => NetworkException(
    message: 'Resource not found. Please try again.',
    statusCode: 404,
    code: 'NOT_FOUND',
  );

  @override
  String toString() => 'NetworkException[$statusCode]: $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'AUTH_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );

  factory AuthException.invalidCredentials() => AuthException(
    message: 'Invalid email or password. Please try again.',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthException.userNotFound() => AuthException(
    message: 'User account not found. Please sign up.',
    code: 'USER_NOT_FOUND',
  );

  factory AuthException.userAlreadyExists() => AuthException(
    message: 'Email already registered. Please log in or use another email.',
    code: 'USER_EXISTS',
  );

  factory AuthException.weakPassword() => AuthException(
    message: 'Password is too weak. Use at least 8 characters with numbers and symbols.',
    code: 'WEAK_PASSWORD',
  );

  factory AuthException.sessionExpired() => AuthException(
    message: 'Your session has expired. Please log in again.',
    code: 'SESSION_EXPIRED',
  );

  factory AuthException.verification() => AuthException(
    message: 'Email verification failed. Please check your email.',
    code: 'VERIFICATION_FAILED',
  );

  @override
  String toString() => 'AuthException: $message';
}

/// Validation-related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException({
    required String message,
    this.fieldErrors,
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'VALIDATION_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );

  factory ValidationException.emailInvalid() => ValidationException(
    message: 'Please enter a valid email address.',
    code: 'EMAIL_INVALID',
  );

  factory ValidationException.passwordMismatch() => ValidationException(
    message: 'Passwords do not match. Please try again.',
    code: 'PASSWORD_MISMATCH',
  );

  factory ValidationException.emptyField(String fieldName) => ValidationException(
    message: '$fieldName cannot be empty.',
    code: 'EMPTY_FIELD',
  );

  @override
  String toString() => 'ValidationException: $message';
}

/// Permission-related exceptions
class PermissionException extends AppException {
  final String permission;

  PermissionException({
    required String message,
    required this.permission,
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
    stackTrace: stackTrace,
  );

  factory PermissionException.camera() => PermissionException(
    message: 'Camera access denied. Please enable it in settings to take photos.',
    permission: 'CAMERA',
    code: 'CAMERA_DENIED',
  );

  factory PermissionException.gallery() => PermissionException(
    message: 'Gallery access denied. Please enable it in settings to pick photos.',
    permission: 'STORAGE',
    code: 'STORAGE_DENIED',
  );

  factory PermissionException.location() => PermissionException(
    message: 'Location access denied. Please enable it in settings to find nearby stores.',
    permission: 'LOCATION',
    code: 'LOCATION_DENIED',
  );

  @override
  String toString() => 'PermissionException[$permission]: $message';
}

/// General data/operation exceptions
class DataException extends AppException {
  DataException({
    required String message,
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'DATA_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );

  factory DataException.empty() => DataException(
    message: 'No data available. Please try again later.',
    code: 'EMPTY_DATA',
  );

  factory DataException.corruptedData() => DataException(
    message: 'Data is corrupted. Please try again.',
    code: 'CORRUPTED_DATA',
  );

  factory DataException.unsupportedFormat() => DataException(
    message: 'Unsupported file format. Please try again.',
    code: 'UNSUPPORTED_FORMAT',
  );

  @override
  String toString() => 'DataException: $message';
}

/// Unknown/Unexpected exceptions
class UnknownException extends AppException {
  UnknownException({
    required String message,
    String? code,
    required dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code ?? 'UNKNOWN_ERROR',
    originalException: originalException,
    stackTrace: stackTrace,
  );

  factory UnknownException.from(dynamic error, [StackTrace? stackTrace]) {
    String message = 'An unexpected error occurred. Please try again.';
    if (error is Exception) {
      message = error.toString();
    }
    return UnknownException(
      message: message,
      originalException: error,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => 'UnknownException: $message';
}

