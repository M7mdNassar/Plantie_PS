import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:plantie/config/app_config.dart';
import '../../config/environment.dart';
import '../../generated/l10n.dart';
import '../../layout/plantie_layout.dart';
import '../../models/user/user_model.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/local/history_db.dart';
import '../../shared/network/local/local_user_storage.dart';
import '../../shared/network/remote/supabase_service.dart';
import '../../shared/network/remote/supabase_auth_service.dart';
import '../../shared/network/local/detection_upload_service.dart';
import '../../shared/network/local/social_upload_service.dart';
import '../../shared/styles/app_colors.dart';
import '../Detection/Classification/plant_disease_pipeline.dart';
import '../OnBoarding/on_boarding_screen.dart';
import '../Registration/registration_screen.dart';

class LottieLoadingScreen extends StatefulWidget {
  const LottieLoadingScreen({super.key});

  @override
  State<LottieLoadingScreen> createState() => _LottieLoadingScreenState();
}

class _LottieLoadingScreenState extends State<LottieLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final stopwatch = Stopwatch()..start();
    Widget startWidget = const RegistrationScreen();

    try {
      // ConfigManager already initialized in main.dart (loaded cache)
      // No network call here.

      // ----- 1. Initialize Supabase -----
      await Supabase.initialize(
        url: Environment.supabaseUrl,
        anonKey: Environment.supabaseAnonKey,
      );
      supabaseService.initialize(Supabase.instance.client);

      // ----- 2. Initialize offline services (parallel) -----
      await Future.wait([
        PlantDiseasePipeline.init(),
        HistoryDBHelper().database,
      ]);

      // Start upload services
      detectionUploadService;
      socialUploadService;
      debugPrint('✅ Upload services initialized');

      // ----- 3. Version check (uses cached config) -----
      final shouldUpdate = await _checkVersion();
      if (shouldUpdate) {
        startWidget = const UpdateRequiredScreen();
        if (stopwatch.elapsedMilliseconds < 2000) {
          await Future.delayed(
            Duration(milliseconds: 2000 - stopwatch.elapsedMilliseconds),
          );
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => startWidget),
          );
        }
        return;
      }

      // ----- 4. Routing (offline‑first) -----
      final onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;

      if (!onBoarding) {
        startWidget = const OnBoardingScreen();
      } else {
        final hasUser = await LocalUserStorage.hasExistingUser();
        if (hasUser) {
          final user = await LocalUserStorage.loadUser();
          if (user != null) {
            CurrentUser.setUser(user);
            debugPrint('✅ User loaded locally: ${user.id} - ${user.name}');
            startWidget = const AppLayout();

            // Background sync – no need to wait
            unawaited(SupabaseAuthService().syncUserIfNeeded(user.id));
          } else {
            startWidget = const RegistrationScreen();
          }
        } else {
          startWidget = const RegistrationScreen();
        }
      }
    } catch (e) {
      debugPrint('⚠️ Initialization Error: $e');
      startWidget = const RegistrationScreen();
    }

    // Minimal Lottie visibility
    if (stopwatch.elapsedMilliseconds < 2000) {
      await Future.delayed(
        Duration(milliseconds: 2000 - stopwatch.elapsedMilliseconds),
      );
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => startWidget),
      );
    }
  }

  // ----- Version check (uses cached config) -----
  Future<bool> _checkVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final minVersion = AppConfig.minSupportedVersion; // uses cached or default
      if (_compareVersions(currentVersion, minVersion) < 0) {
        debugPrint('⚠️ App version $currentVersion is below minimum $minVersion');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('⚠️ Version check failed: $e');
      return false;
    }
  }

  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map(int.parse).toList();
    final parts2 = v2.split('.').map(int.parse).toList();
    for (int i = 0; i < parts1.length && i < parts2.length; i++) {
      if (parts1[i] != parts2[i]) {
        return parts1[i].compareTo(parts2[i]);
      }
    }
    return parts1.length.compareTo(parts2.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}


// ----- Full-screen update required screen (localised) -----
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.system_update_rounded, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                S.of(context).update_required_title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).update_required_message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Open app store or play store
                },
                icon: const Icon(Icons.update_rounded),
                label: Text(S.of(context).update_now),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}