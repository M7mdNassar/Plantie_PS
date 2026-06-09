import 'package:flutter/material.dart';

/// Responsive text sizing system with accessibility-first approach
/// Provides consistent text scaling across the app with max/min limits
///
/// Usage:
/// ResponsiveText.headline(context) -> 24pt with limits 20-28pt
/// ResponsiveText.title(context) -> 16pt with limits 14-18pt
class ResponsiveText {
  static double _getBaseScale(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.5);
  }

  /// Headlines - Primary titles (Home, Weather labels, etc.)
  /// Base: 24pt | Range: 20-28pt
  static double headline(BuildContext context) {
    final scale = _getBaseScale(context);
    return (24 * scale).clamp(20, 28);
  }

  /// Section titles and important headers
  /// Base: 22pt | Range: 18-26pt
  static double headlineSmall(BuildContext context) {
    final scale = _getBaseScale(context);
    return (22 * scale).clamp(18, 26);
  }

  /// Large titles (plant names, section headers)
  /// Base: 16pt | Range: 14-18pt
  static double title(BuildContext context) {
    final scale = _getBaseScale(context);
    return (16 * scale).clamp(14, 18);
  }

  /// Regular body text
  /// Base: 14pt | Range: 12-16pt
  static double body(BuildContext context) {
    final scale = _getBaseScale(context);
    return (14 * scale).clamp(12, 16);
  }

  /// Smaller body text
  /// Base: 13pt | Range: 11-15pt
  static double bodySmall(BuildContext context) {
    final scale = _getBaseScale(context);
    return (13 * scale).clamp(11, 15);
  }

  /// Labels and tags
  /// Base: 12pt | Range: 10-14pt
  static double label(BuildContext context) {
    final scale = _getBaseScale(context);
    return (12 * scale).clamp(10, 14);
  }

  /// Small labels and captions
  /// Base: 11pt | Range: 9-13pt
  static double labelSmall(BuildContext context) {
    final scale = _getBaseScale(context);
    return (11 * scale).clamp(9, 13);
  }

  /// Icon sizes based on text scale
  /// For body text icons
  static double iconSizeMedium(BuildContext context) {
    final scale = _getBaseScale(context);
    return (22 * scale).clamp(18, 28);
  }

  /// Icon sizes for titles
  static double iconSizeLarge(BuildContext context) {
    final scale = _getBaseScale(context);
    return (28 * scale).clamp(24, 32);
  }

  /// Icon sizes for small elements
  static double iconSizeSmall(BuildContext context) {
    final scale = _getBaseScale(context);
    return (18 * scale).clamp(16, 22);
  }

  /// Responsive padding with limits
  static double padding(BuildContext context, double baseValue) {
    final scale = _getBaseScale(context);
    return (baseValue * scale).clamp(baseValue * 0.8, baseValue * 1.3);
  }

  /// Emoji size (large, visual elements)
  /// Base: 48pt | Range: 40-60pt
  static double emojiLarge(BuildContext context) {
    final scale = _getBaseScale(context);
    return (48 * scale).clamp(40, 60);
  }

  /// Small emoji (in selection cards)
  /// Base: 36pt | Range: 30-44pt
  static double emojiSmall(BuildContext context) {
    final scale = _getBaseScale(context);
    return (36 * scale).clamp(30, 44);
  }

  /// Get scale factor for responsive spacing
  static double getScale(BuildContext context) {
    return _getBaseScale(context).clamp(1.0, 1.3);
  }
}
