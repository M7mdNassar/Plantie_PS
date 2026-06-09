import 'package:flutter/material.dart';

enum InsightLevel { good, warning, critical }

class FarmingInsight {
  final String title;
  final String message;
  final IconData icon;
  final InsightLevel level;

  FarmingInsight({
    required this.title,
    required this.message,
    required this.icon,
    required this.level,
  });
}
