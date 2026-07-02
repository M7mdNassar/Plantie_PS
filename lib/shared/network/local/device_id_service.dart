import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class DeviceIdService {
  static const String _deviceIdKey = 'device_id';
  static String? _cachedDeviceId;

  // Fixed namespace for UUID v5 (any valid UUID will do)
  static const String _namespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';

  static Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) return _cachedDeviceId!;

    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString(_deviceIdKey);

    if (storedId != null && storedId.isNotEmpty) {
      // Validate that it's a UUID (optional but good)
      _cachedDeviceId = storedId;
      return storedId;
    }

    // Generate a new device ID
    final String newId = await _generateDeviceId();
    await prefs.setString(_deviceIdKey, newId);
    _cachedDeviceId = newId;
    return newId;
  }

  static Future<String> _generateDeviceId() async {
    String rawId;
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        rawId = androidInfo.id ?? '';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        rawId = iosInfo.identifierForVendor ?? '';
      } else {
        rawId = '';
      }
    } catch (e) {
      debugPrint('⚠️ Failed to get device info, falling back to UUID: $e');
      rawId = '';
    }

    if (rawId.isEmpty) {
      // Fallback: generate a random UUID (will be stored and reused)
      return const Uuid().v4();
    }

    // Generate a deterministic UUID v5 from the raw device identifier
    final uuid = Uuid();
    return uuid.v5(_namespace, rawId).toString();
  }
}