import 'package:flutter/material.dart';


/// Notification types with different visual styles
enum NotificationType {
  success,
  error,
  warning,
  info,
}

/// Modern, trendy notification/snackbar service
/// Replaces FlutterToast with Material Design 3 inspired animated snackbars
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static ScaffoldMessengerState? _scaffoldMessenger;

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  /// Initialize with BuildContext (call once in your app)
  static void initialize(BuildContext context) {
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  /// Show notification with message and type
  static void show({
    required String title,
    String? message,
    required NotificationType type,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _show(
      title: title,
      message: message,
      type: type,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show success notification (✓ Green)
  static void success({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
  }) {
    _show(
      title: title,
      message: message,
      type: NotificationType.success,
      duration: duration,
      onAction: onAction,
    );
  }

  /// Show error notification (✕ Red)
  static void error({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onAction,
    String? actionLabel = 'RETRY',
  }) {
    _show(
      title: title,
      message: message,
      type: NotificationType.error,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show warning notification (⚠ Orange)
  static void warning({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
  }) {
    _show(
      title: title,
      message: message,
      type: NotificationType.warning,
      duration: duration,
      onAction: onAction,
    );
  }

  /// Show info notification (ℹ Blue)
  static void info({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
  }) {
    _show(
      title: title,
      message: message,
      type: NotificationType.info,
      duration: duration,
      onAction: onAction,
    );
  }

  /// Show exception notification with auto-parsing


  /// Internal show implementation
  static void _show({
    required String title,
    String? message,
    required NotificationType type,
    required Duration duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // Prevent showing if scaffold messenger is not initialized
    if (_scaffoldMessenger == null) return;

    // Remove any previously shown snackbar
    _scaffoldMessenger!.clearSnackBars();

    final colors = _getColorsForType(type);
    final icon = _getIconForType(type);

    final snackBar = SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: colors['icon'], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (message != null && message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Colors.white70,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
      backgroundColor: colors['background'] as Color,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
            label: actionLabel,
            textColor: colors['action'] as Color,
            onPressed: onAction,
          )
          : null,
    );

    _scaffoldMessenger!.showSnackBar(snackBar);
  }

  /// Get colors based on notification type
  static Map<String, dynamic> _getColorsForType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return {
          'background': const Color(0xFF4CAF50), // Material Green
          'icon': Colors.white,
          'action': const Color(0xFFE8F5E9),
        };
      case NotificationType.error:
        return {
          'background': const Color(0xFFF44336), // Material Red
          'icon': Colors.white,
          'action': const Color(0xFFFFEBEE),
        };
      case NotificationType.warning:
        return {
          'background': const Color(0xFFFFA726), // Material Orange
          'icon': Colors.white,
          'action': const Color(0xFFFFF3E0),
        };
      case NotificationType.info:
        return {
          'background': const Color(0xFF2196F3), // Material Blue
          'icon': Colors.white,
          'action': const Color(0xFFE3F2FD),
        };
    }
  }

  /// Get icon based on notification type
  static IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning_amber;
      case NotificationType.info:
        return Icons.info;
    }
  }

}

