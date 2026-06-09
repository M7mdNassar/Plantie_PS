import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';
import 'notification_service.dart';

/// Centralized error handler for the entire app
/// Handles exception mapping, logging, user notification, and retry logic
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();

  bool _enableLogging = true;
  List<AppException> _errorHistory = [];
  static const int _maxErrorHistorySize = 50;

  ErrorHandler._internal();

  factory ErrorHandler() {
    return _instance;
  }

  /// Initialize error handler (call in main.dart)
  void initialize({bool enableLogging = true}) {
    _enableLogging = enableLogging;
  }

  /// Main error handler method - converts any error to AppException
  static AppException handle(
    dynamic error, {
    StackTrace? stackTrace,
    bool notify = true,
    VoidCallback? onRetry,
  }) {
    final exception = _parseException(error, stackTrace);
    _instance._logError(exception);

    if (notify) {
      NotificationService.showException(exception, onRetry: onRetry);
    }

    _instance._addToHistory(exception);
    return exception;
  }

  /// Handle network errors specifically
  static NetworkException handleNetworkError(
    dynamic error, {
    StackTrace? stackTrace,
    bool notify = true,
    VoidCallback? onRetry,
  }) {
    NetworkException networkException;

    if (error is DioException) {
      networkException = _parseDioException(error);
    } else {
      networkException = NetworkException(
        message: error.toString(),
        originalException: error,
        stackTrace: stackTrace,
      );
    }

    _instance._logError(networkException);

    if (notify) {
      NotificationService.showException(networkException, onRetry: onRetry);
    }

    _instance._addToHistory(networkException);
    return networkException;
  }

  /// Handle auth errors specifically
  static AuthException handleAuthError(
    dynamic error, {
    StackTrace? stackTrace,
    bool notify = true,
    VoidCallback? onRetry,
  }) {
    final exception = _parseAuthException(error, stackTrace);
    _instance._logError(exception);

    if (notify) {
      NotificationService.showException(exception, onRetry: onRetry);
    }

    _instance._addToHistory(exception);
    return exception;
  }

  /// Handle validation errors
  static ValidationException handleValidationError(
    String message, {
    Map<String, String>? fieldErrors,
    bool notify = true,
  }) {
    final exception = ValidationException(
      message: message,
      fieldErrors: fieldErrors,
    );
    _instance._logError(exception);

    if (notify) {
      NotificationService.warning(title: 'Validation Error', message: message);
    }

    _instance._addToHistory(exception);
    return exception;
  }

  /// Handle permission errors
  static PermissionException handlePermissionError(
    String permission, {
    bool notify = true,
  }) {
    late final PermissionException exception;

    switch (permission.toLowerCase()) {
      case 'camera':
        exception = PermissionException.camera();
        break;
      case 'gallery':
      case 'storage':
        exception = PermissionException.gallery();
        break;
      case 'location':
        exception = PermissionException.location();
        break;
      default:
        exception = PermissionException(
          message: 'Permission denied for $permission',
          permission: permission,
        );
    }

    _instance._logError(exception);

    if (notify) {
      NotificationService.showException(exception);
    }

    _instance._addToHistory(exception);
    return exception;
  }

  /// Show success notification
  static void showSuccess({
    required String title,
    String? message,
  }) {
    NotificationService.success(title: title, message: message);
  }

  /// Show info notification
  static void showInfo({
    required String title,
    String? message,
  }) {
    NotificationService.info(title: title, message: message);
  }

  /// Get error history (useful for debugging)
  static List<AppException> getErrorHistory() {
    return List.unmodifiable(_instance._errorHistory);
  }

  /// Clear error history
  static void clearErrorHistory() {
    _instance._errorHistory.clear();
  }

  // ==================== Private Methods ====================

  /// Parse any error to AppException
  static AppException _parseException(
    dynamic error,
    StackTrace? stackTrace,
  ) {
    if (error is AppException) {
      return error;
    } else if (error is DioException) {
      return _parseDioException(error);
    } else if (error is FormatException) {
      return DataException.corruptedData();
    } else if (error is ArgumentError) {
      return ValidationException(message: error.message.toString());
    } else if (error is Exception) {
      return UnknownException.from(error, stackTrace);
    } else {
      return UnknownException.from(error, stackTrace);
    }
  }

  /// Parse Dio exceptions to NetworkException
  static NetworkException _parseDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException.timeout();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 400) {
          return NetworkException.badRequest();
        } else if (statusCode == 401) {
          return NetworkException.unauthorized();
        } else if (statusCode == 403) {
          return NetworkException.forbidden();
        } else if (statusCode == 404) {
          return NetworkException.notFound();
        } else if (statusCode != null && statusCode >= 500) {
          return NetworkException.serverError(statusCode);
        }
        return NetworkException(
          message: error.response?.statusMessage ?? 'Server error',
          statusCode: statusCode,
          originalException: error,
        );

      case DioExceptionType.connectionError:
        return NetworkException.noInternet();

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Network security error. Please contact support.',
          code: 'BAD_CERTIFICATE',
          originalException: error,
        );

      case DioExceptionType.unknown:
        return NetworkException(
          message: 'Network error. Please try again.',
          code: 'UNKNOWN',
          originalException: error,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request cancelled.',
          code: 'REQUEST_CANCELLED',
          originalException: error,
        );
    }
  }

  /// Parse authentication errors
  static AuthException _parseAuthException(
    dynamic error,
    StackTrace? stackTrace,
  ) {
    if (error is AuthException) {
      return error;
    }

    final message = error.toString().toLowerCase();

    if (message.contains('invalid') || message.contains('credentials')) {
      return AuthException.invalidCredentials();
    } else if (message.contains('not found') || message.contains('does not exist')) {
      return AuthException.userNotFound();
    } else if (message.contains('already exists') || message.contains('registered')) {
      return AuthException.userAlreadyExists();
    } else if (message.contains('weak') || message.contains('password')) {
      return AuthException.weakPassword();
    } else if (message.contains('expired') || message.contains('session')) {
      return AuthException.sessionExpired();
    }

    return AuthException(
      message: error.toString(),
      originalException: error,
      stackTrace: stackTrace,
    );
  }

  /// Log error to console and file
  void _logError(AppException exception) {
    if (!_enableLogging) return;

    String severity = 'ERROR';
    if (exception is ValidationException) {
      severity = 'WARNING';
    } else if (exception is PermissionException) {
      severity = 'INFO';
    }

    developer.log(
      exception.message,
      level: severity == 'ERROR' ? 1000 : severity == 'WARNING' ? 800 : 500,
      name: exception.runtimeType.toString(),
      error: exception.originalException,
      stackTrace: exception.stackTrace,
    );
  }

  /// Add exception to history (limited size)
  void _addToHistory(AppException exception) {
    _errorHistory.insert(0, exception);
    if (_errorHistory.length > _maxErrorHistorySize) {
      _errorHistory.removeLast();
    }
  }
}




