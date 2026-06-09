import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plantie/config/environment.dart';
import 'package:plantie/shared/network/local/cache_helper.dart';
import 'package:plantie/shared/styles/themes.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'modules/Community/cubit/cubit.dart';
import 'modules/Detection/cubit/cubit.dart';
import 'modules/Home/cubit/cubit.dart';
import 'modules/Profile/cubit/cubit.dart';
import 'modules/SplashScreen/lottie_loading_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env once – needed for App title and Supabase URL later in LottieLoadingScreen
  await dotenv.load(fileName: Environment.fileName);

  // Minimal required initialisation (theme)
  await CacheHelper.init();
  final isDark = CacheHelper.getData(key: 'isDark') ?? false;

  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..changeAppMode(fromShared: isDark)),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => DetectionCubit()),
        BlocProvider(create: (context) => CommunityCubit()),
      ],
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final appTitle = Environment.appName.isNotEmpty ? Environment.appName : 'Plantie';

          return MaterialApp(
            title: appTitle,
            locale: Locale(cubit.currentLanguage),
            debugShowCheckedModeBanner: Environment.isDevelopment,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const LottieLoadingScreen(), // Immediate Lottie screen
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}