import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static bool get isDevelopment =>
      const String.fromEnvironment('ENV') == 'dev' ||
          (const String.fromEnvironment('ENV').isEmpty && kDebugMode);

  static String get fileName => isDevelopment ? '.env.dev' : '.env.prod';

  static String get supabaseUrl =>
      dotenv.maybeGet('SUPABASE_URL') ?? '';

  static String get supabaseAnonKey =>
      dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';

  static String get appName =>
      dotenv.maybeGet('APP_NAME') ?? (isDevelopment ? 'Plantie Dev' : 'Plantie');

  // --- New AdMob getters ---
  static String get androidRewardedAdUnitId =>
      dotenv.maybeGet('ANDROID_REWARDED_AD_UNIT_ID') ?? '';

  static String get iosRewardedAdUnitId =>
      dotenv.maybeGet('IOS_REWARDED_AD_UNIT_ID') ?? '';

  // Helper that returns the correct ID for the current platform in production
  static String get productionRewardedAdUnitId =>
      (() {
        if (Platform.isAndroid) {
          final id = androidRewardedAdUnitId;
          if (id.isEmpty) {
            throw Exception('ANDROID_REWARDED_AD_UNIT_ID not set in .env.prod');
          }
          return id;
        } else if (Platform.isIOS) {
          final id = iosRewardedAdUnitId;
          if (id.isEmpty) {
            throw Exception('IOS_REWARDED_AD_UNIT_ID not set in .env.prod');
          }
          return id;
        } else {
          throw Exception('Unsupported platform');
        }
      })();

  // Test IDs – official Google test IDs
  static String get testRewardedAdUnitId =>
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';

  // Convenience method to return the correct ID based on build mode
  static String get rewardedAdUnitId {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction ? productionRewardedAdUnitId : testRewardedAdUnitId;
  }
}