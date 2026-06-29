import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/environment.dart';
import '../../layout/plantie_layout.dart';
import '../../models/user/user_model.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/local/history_db.dart';
import '../../shared/network/local/local_user_storage.dart';
import '../../shared/network/remote/supabase_service.dart';
import '../../shared/network/remote/supabase_auth_service.dart';
import '../../shared/network/local/detection_upload_service.dart';
import '../../shared/network/local/social_upload_service.dart';
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
      await Supabase.initialize(
        url: Environment.supabaseUrl,
        anonKey: Environment.supabaseAnonKey,
      );
      supabaseService.initialize(Supabase.instance.client);

      // Fire these in parallel – they are independent
      await Future.wait([
        PlantDiseasePipeline.init(),
        HistoryDBHelper().database,
      ]);

      // Start the upload services (singletons are initialized)
      // Reference them to ensure they are loaded and listening.
      detectionUploadService;
      socialUploadService;
      debugPrint('✅ Upload services initialized');

      // Routing
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

            // One‑time background sync – no need to wait
            unawaited(SupabaseAuthService().syncUserIfNeeded(user.id));
          } else {
            startWidget = const RegistrationScreen();
          }
        } else {
          startWidget = const RegistrationScreen();
        }
      }
    } catch (e) {
      debugPrint('Initialization Error: $e');
      startWidget = const RegistrationScreen();
    }

    // Minimal delay – ensures Lottie is visible at least for a short time
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