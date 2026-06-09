import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // Use kDebugMode as a fallback if the ENV flag is missing (e.g. running from Xcode)
  static bool get isDevelopment => 
      const String.fromEnvironment('ENV') == 'dev' || 
      (const String.fromEnvironment('ENV').isEmpty && kDebugMode);

  static String get fileName => isDevelopment ? '.env.dev' : '.env.prod';

  // Use maybeGet() for safe access with fallbacks to prevent NotInitializedError
  static String get supabaseUrl =>
      dotenv.maybeGet('SUPABASE_URL') ?? '';

  static String get supabaseAnonKey =>
      dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';

  static String get appName =>
      dotenv.maybeGet('APP_NAME') ?? (isDevelopment ? 'Plantie Dev' : 'Plantie');
}


