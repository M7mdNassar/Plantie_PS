import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:plantie/shared/network/local/cache_helper.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';
import 'package:plantie/shared/network/remote/supabase_auth_service.dart';

class ConfigManager {
  static final ConfigManager _instance = ConfigManager._internal();
  factory ConfigManager() => _instance;
  ConfigManager._internal();

  Map<String, dynamic> _config = {};
  DateTime? _lastFetchTime;
  bool _isFetching = false;
  bool _hasCachedConfig = false; // ✅ track if we have any cached config

  static const String _defaultMinVersion = '1.0.0';

  void init() {
    _loadFromCache();
  }

  void _loadFromCache() {
    final cached = CacheHelper.getData(key: 'app_config');
    if (cached != null && cached is String) {
      try {
        _config = Map<String, dynamic>.from(jsonDecode(cached));
        _hasCachedConfig = true;
        debugPrint('✅ ConfigManager loaded from cache');
      } catch (e) {
        _hasCachedConfig = false;
        debugPrint('❌ Failed to parse cached config: $e');
      }
    } else {
      _hasCachedConfig = false;
      debugPrint('ℹ️ No cached config found');
    }
  }

  void _saveToCache() {
    try {
      CacheHelper.saveData(key: 'app_config', value: jsonEncode(_config));
      _hasCachedConfig = true; // after saving, mark as cached
    } catch (e) {
      debugPrint('❌ Failed to cache config: $e');
    }
  }

  Future<void> fetchIfNeeded({bool force = false}) async {
    if (_isFetching) return;
    if (!force && _isFresh()) return;

    final hasInternet = await SupabaseAuthService().isConnectedFast();
    if (!hasInternet) {
      debugPrint('📡 No internet – skipping config fetch');
      return;
    }

    _isFetching = true;
    try {
      final response = await supabaseService.client
          .from('app_config')
          .select()
          .timeout(const Duration(seconds: 5));

      final configMap = <String, dynamic>{};
      for (final row in response) {
        configMap[row['key']] = row['value'];
      }

      _config = configMap;
      _saveToCache(); // this sets _hasCachedConfig = true
      _lastFetchTime = DateTime.now();

      debugPrint('✅ ConfigManager fetched from Supabase (${configMap.length} keys)');
    } catch (e) {
      debugPrint('⚠️ ConfigManager fetch failed: $e');
    } finally {
      _isFetching = false;
    }
  }

  bool _isFresh() {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < const Duration(minutes: 5);
  }

  // ✅ public getter
  bool get hasCachedConfig => _hasCachedConfig;

  dynamic get(String key) => _config[key];

  String getString(String key, {String? fallback}) {
    final value = _config[key];
    if (value is String) return value;
    if (value != null) return value.toString();
    return fallback ?? '';
  }

  bool getBool(String key, {bool? fallback}) {
    final value = _config[key];
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback ?? false;
  }

  String get minSupportedVersion =>
      getString('min_supported_version', fallback: _defaultMinVersion);

  bool? isFeatureEnabled(String featureName) {
    final key = 'feature_${featureName}_enabled';
    return getBool(key, fallback: null);
  }
}