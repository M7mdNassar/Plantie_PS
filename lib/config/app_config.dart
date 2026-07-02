import 'config_manager.dart';

class AppConfig {
  static final ConfigManager _manager = ConfigManager();

  // Delegate to manager
  static String getString(String key, {String? fallback}) =>
      _manager.getString(key, fallback: fallback);

  static bool getBool(String key, {bool? fallback}) =>
      _manager.getBool(key, fallback: fallback);

  // Specific getters – now use manager, NO hardcoded fallbacks
  static String get chatBaseUrl =>
      getString('chat_ai_base_url') ?? ''; // fallback empty

  static String get chatEndpoint =>
      getString('chat_ai_endpoint') ?? '';

  static String get minSupportedVersion =>
      _manager.minSupportedVersion; // uses default

  static bool get isChatEnabled =>
      _manager.isFeatureEnabled('chat') ?? false; // defaults to false if missing

  static bool get isCommunityEnabled =>
      _manager.isFeatureEnabled('community') ?? false;

  static bool get isWeatherEnabled =>
      _manager.isFeatureEnabled('weather') ?? false;

  // We'll keep the static init/loadFromCache for backward compatibility,
  // but they now just call the manager.
  static void init(Map<String, dynamic> config) {
    // This method might be called from background fetch – we'll just let manager handle.
    // But we can update manager's config directly.
    // For simplicity, we'll not use this static init; instead we call manager.fetchIfNeeded.
    // We'll keep it as a no-op or forward to manager.
  }

  static void loadFromCache() {
    // Already done in ConfigManager.init()
    // but keep for legacy calls
    _manager.init();
  }
}