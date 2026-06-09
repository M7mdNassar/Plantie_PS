import 'package:flutter/foundation.dart';

/// Performance monitoring utility for tracking app metrics
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();

  factory PerformanceMonitor() {
    return _instance;
  }

  PerformanceMonitor._internal();

  final Map<String, PerformanceMetric> _metrics = {};

  /// Start measuring duration for a task
  void startTimer(String label) {
    _metrics[label] = PerformanceMetric(
      label: label,
      startTime: DateTime.now(),
    );
    debugPrint('⏱️  Started: $label');
  }

  /// Stop measuring and get duration
  Duration? stopTimer(String label) {
    final metric = _metrics[label];

    if (metric == null) {
      debugPrint('❌ No timer found for: $label');
      return null;
    }

    metric.endTime = DateTime.now();
    metric.duration = metric.endTime!.difference(metric.startTime);

    debugPrint(
      '✅ Completed: $label - ${metric.duration!.inMilliseconds}ms',
    );

    return metric.duration;
  }

  /// Get all recorded metrics
  Map<String, Duration?> getAllMetrics() {
    return {
      for (var entry in _metrics.entries)
        entry.key: entry.value.duration
    };
  }

  /// Get formatted report
  String getReport() {
    StringBuffer report = StringBuffer('Performance Report\n');
    report.write('=' * 40 + '\n');

    int totalDuration = 0;
    for (var entry in _metrics.entries) {
      final duration = entry.value.duration?.inMilliseconds ?? 0;
      totalDuration += duration;
      report.write('${entry.key}: ${duration}ms\n');
    }

    report.write('=' * 40 + '\n');
    report.write('Total: ${totalDuration}ms\n');
    report.write('Count: ${_metrics.length}');

    return report.toString();
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    debugPrint('📊 Cleared all metrics');
  }

  /// Get metric for specific label
  Duration? getMetric(String label) {
    return _metrics[label]?.duration;
  }

  /// Print all metrics
  void printAll() {
    debugPrint(getReport());
  }

  /// Check if metric took too long (useful for performance debugging)
  bool isSlowMetric(String label, Duration threshold) {
    final duration = _metrics[label]?.duration;
    if (duration == null) return false;

    final isSlow = duration > threshold;
    if (isSlow) {
      debugPrint(
        '🐢 SLOW METRIC: $label took ${duration.inMilliseconds}ms '
        '(threshold: ${threshold.inMilliseconds}ms)',
      );
    }
    return isSlow;
  }
}

/// Model for storing performance metric data
class PerformanceMetric {
  final String label;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;

  PerformanceMetric({
    required this.label,
    required this.startTime,
  });

  @override
  String toString() => '$label: ${duration?.inMilliseconds}ms';
}

/// Helper for measuring widget build time
class BuildTimeMeasurer {
  static final BuildTimeMeasurer _instance = BuildTimeMeasurer._internal();

  factory BuildTimeMeasurer() {
    return _instance;
  }

  BuildTimeMeasurer._internal();

  final Map<String, List<Duration>> _buildTimes = {};

  /// Record a build time for a widget
  void recordBuildTime(String widgetName, Duration duration) {
    if (!_buildTimes.containsKey(widgetName)) {
      _buildTimes[widgetName] = [];
    }
    _buildTimes[widgetName]!.add(duration);

    // Alert if build is slow
    if (duration.inMilliseconds > 16) { // 60 FPS = 16.67ms per frame
      debugPrint(
        '🐢 SLOW BUILD: $widgetName took ${duration.inMilliseconds}ms',
      );
    }
  }

  /// Get average build time for widget
  Duration? getAverageBuildTime(String widgetName) {
    final times = _buildTimes[widgetName];
    if (times == null || times.isEmpty) return null;

    int total = 0;
    for (final duration in times) {
      total += duration.inMicroseconds;
    }

    return Duration(microseconds: total ~/ times.length);
  }

  /// Get build time statistics
  String getStatistics() {
    StringBuffer stats = StringBuffer('Build Time Statistics\n');
    stats.write('=' * 40 + '\n');

    for (var entry in _buildTimes.entries) {
      final times = entry.value;
      final average = getAverageBuildTime(entry.key);
      final max = times.reduce((a, b) => a > b ? a : b);
      final min = times.reduce((a, b) => a < b ? a : b);

      stats.write(
        '${entry.key}:\n'
        '  Avg: ${average?.inMilliseconds}ms, '
        'Max: ${max.inMilliseconds}ms, '
        'Min: ${min.inMilliseconds}ms, '
        'Count: ${times.length}\n',
      );
    }

    return stats.toString();
  }

  /// Clear all statistics
  void clearStatistics() {
    _buildTimes.clear();
    debugPrint('📊 Cleared build statistics');
  }
}

/// Memory profiler helper
class MemoryProfiler {
  static final MemoryProfiler _instance = MemoryProfiler._internal();

  factory MemoryProfiler() {
    return _instance;
  }

  MemoryProfiler._internal();

  /// Log memory warning for large objects
  static void checkObjectSize(String objectName, int sizeInBytes) {
    final sizeInMB = sizeInBytes / (1024 * 1024);

    if (sizeInMB > 10) {
      debugPrint(
        '⚠️  LARGE OBJECT: $objectName is ${sizeInMB.toStringAsFixed(2)}MB',
      );
    } else if (sizeInMB > 1) {
      debugPrint(
        '📦 MEDIUM OBJECT: $objectName is ${sizeInMB.toStringAsFixed(2)}MB',
      );
    }
  }

  /// Check list size
  static void checkListSize<T>(String listName, List<T> list) {
    if (list.length > 1000) {
      debugPrint(
        '⚠️  LARGE LIST: $listName contains ${list.length} items',
      );
    }
  }

  /// Check collection size
  static void checkMapSize<K, V>(String mapName, Map<K, V> map) {
    if (map.length > 500) {
      debugPrint(
        '⚠️  LARGE MAP: $mapName contains ${map.length} entries',
      );
    }
  }
}

/// Usage Example:
///
/// // Start measuring
/// PerformanceMonitor().startTimer('load_plants');
///
/// // Do work
/// await loadPlants();
///
/// // Stop and get duration
/// PerformanceMonitor().stopTimer('load_plants');
///
/// // Check if slow
/// PerformanceMonitor().isSlowMetric('load_plants', Duration(milliseconds: 500));
///
/// // Print all metrics
/// PerformanceMonitor().printAll();

