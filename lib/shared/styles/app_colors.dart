import 'package:flutter/material.dart';

/// Modern Color Palette System
/// Inspired by: iOS, Instagram, TikTok, Modern Apps (2024)

class AppColors {
  // PRIMARY COLORS - Green gradient for plant theme
  static const Color primary = Color(0xFF2E7D32);        // Deep green
  static const Color primaryLight = Color(0xFF66BB6A);   // Light green
  static const Color primaryDark = Color(0xFF1B5E20);    // Dark forest green

  // SECONDARY COLORS - Earth tones and accents
  static const Color secondary = Color(0xFFFFA726);      // Warm orange
  static const Color secondaryLight = Color(0xFFFFB74D); // Light orange
  static const Color tertiary = Color(0xFF42A5F5);       // Sky blue
  static const Color tertiaryLight = Color(0xFF64B5F6);  // Light blue

  // ACCENT COLORS
  static const Color success = Color(0xFF66BB6A);        // Green success
  static const Color warning = Color(0xFFFFB74D);        // Orange warning
  static const Color error = Color(0xFFEF5350);          // Red error
  static const Color info = Color(0xFF42A5F5);           // Blue info

  // LIGHT MODE COLORS
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextTertiary = Color(0xFFBDBDBD);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightDivider = Color(0xFFEEEEEE);
  static const Color lightGradientStart = Color(0xFFF5F9F6);
  static const Color lightGradientEnd = Color(0xFFECF4E6);

  // DARK MODE COLORS
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF808080);
  static const Color darkBorder = Color(0xFF3F3F3F);
  static const Color darkDivider = Color(0xFF404040);
  static const Color darkGradientStart = Color(0xFF1E1E1E);
  static const Color darkGradientEnd = Color(0xFF262626);

  // GRADIENT DEFINITIONS
  static LinearGradient lightGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGradientStart, lightGradientEnd],
  );

  static LinearGradient darkGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkGradientStart, darkGradientEnd],
  );

  static LinearGradient greenGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static LinearGradient orangeGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A50), secondary],
  );

  static LinearGradient purpleGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6F2FF2), Color(0xFFA855A8)],
  );

  static LinearGradient sunsetGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFFA500)],
  );

  // RGBA COLORS FOR SHADOWS AND OVERLAYS
  static Color shadowColorLight = Colors.black.withValues(alpha: 0.08);
  static Color shadowColorDark = Colors.black.withValues(alpha: 0.3);
  static Color overlayColorLight = Colors.black.withValues(alpha: 0.6);
  static Color overlayColorDark = Colors.black.withValues(alpha: 0.7);
}

/// Text color getters based on brightness
Color getTextColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppColors.darkText : AppColors.lightText;
}

Color getTextSecondaryColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
}

Color getSurfaceColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppColors.darkSurface : AppColors.lightSurface;
}

Color getBackgroundColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppColors.darkBackground : AppColors.lightBackground;
}

Color getBorderColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppColors.darkBorder : AppColors.lightBorder;
}

LinearGradient getBackgroundGradient(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppColors.darkGradient : AppColors.lightGradient;
}



