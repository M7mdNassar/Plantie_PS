import 'package:flutter/foundation.dart';

/// Generic cache request helper for network data
class CacheManager<T> {
  final Map<String, CachedData<T>> _cache = {};
  final Duration defaultExpiry;

  CacheManager({this.defaultExpiry = const Duration(hours: 1)});

  /// Cache data with automatic expiry
  void cache(String key, T data, {Duration? expiry}) {
    _cache[key] = CachedData(
      data: data,
      timestamp: DateTime.now(),
      expiry: expiry ?? defaultExpiry,
    );
    debugPrint('Cached: $key');
  }

  /// Get cached data if not expired
  T? get(String key) {
    final cached = _cache[key];

    if (cached == null) {
      return null;
    }

    if (cached.isExpired) {
      _cache.remove(key);
      debugPrint('Cache expired: $key');
      return null;
    }

    debugPrint('Cache hit: $key');
    return cached.data;
  }

  /// Check if cache exists and is valid
  bool isValid(String key) {
    final cached = _cache[key];
    if (cached == null) return false;
    if (cached.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  /// Clear specific cache
  void clear(String key) {
    _cache.remove(key);
    debugPrint('Cleared cache: $key');
  }

  /// Clear all cache
  void clearAll() {
    _cache.clear();
    debugPrint('Cleared all cache');
  }

  /// Get cache statistics
  CacheStats getStats() {
    int validCount = 0;
    int expiredCount = 0;
    int totalSize = 0;

    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredCount++;
      } else {
        validCount++;
      }
      totalSize += entry.key.length; // Approximate
    }

    return CacheStats(
      totalItems: _cache.length,
      validItems: validCount,
      expiredItems: expiredCount,
      approximateSizeKB: totalSize / 1024,
    );
  }

  /// Get cache age for a key
  Duration? getCacheAge(String key) {
    final cached = _cache[key];
    if (cached == null) return null;
    return DateTime.now().difference(cached.timestamp);
  }

  /// Cleanup expired cache entries
  void cleanup() {
    _cache.removeWhere((key, value) => value.isExpired);
    debugPrint('Cache cleanup complete. Remaining: ${_cache.length}');
  }
}

/// Wrapper class for cached data with expiry
class CachedData<T> {
  final T data;
  final DateTime timestamp;
  final Duration expiry;

  CachedData({
    required this.data,
    required this.timestamp,
    required this.expiry,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > expiry;
  }
}

/// Cache statistics
class CacheStats {
  final int totalItems;
  final int validItems;
  final int expiredItems;
  final double approximateSizeKB;

  CacheStats({
    required this.totalItems,
    required this.validItems,
    required this.expiredItems,
    required this.approximateSizeKB,
  });

  @override
  String toString() {
    return 'CacheStats('
        'Total: $totalItems, '
        'Valid: $validItems, '
        'Expired: $expiredItems, '
        'Size: ${approximateSizeKB.toStringAsFixed(2)}KB)';
  }
}

