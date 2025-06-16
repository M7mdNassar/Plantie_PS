import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/shared/bloc_observer.dart';
import 'package:plantie/shared/components/constants.dart';
import 'package:plantie/shared/network/local/cache_helper.dart';
import 'package:plantie/shared/network/local/history_db.dart';
import 'package:plantie/shared/styles/themes.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'models/user/user_model.dart';
import 'modules/Community/cubit/cubit.dart';
import 'modules/Detection/Classification/model_handler.dart';
import 'modules/Detection/cubit/cubit.dart';
import 'modules/Home/cubit/cubit.dart';
import 'modules/OnBoarding/on_boarding_screen.dart';
import 'modules/Profile/cubit/cubit.dart';
import 'modules/SplashScreen/lottie_loading_screen.dart';
import 'modules/WelcomePlantie/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() async {
  // ensure all things (methods done before move on ..)
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ModelHandler.initModel();
  await HistoryDBHelper().database;

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  uId = CacheHelper.getData(key: 'uId') ?? "";

  if (uId != "") {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((doc) {
      CurrentUser.setUser(UserModel.fromJson(doc.data()!));
    }).catchError((error) {});
  }

  Widget widget;

  if (onBoarding == true) {
    if (uId != "") {
      widget = LottieLoadingScreen();
    } else {
      widget = WelcomeScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  const MyApp({
    super.key,
    required this.isDark,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => HomeCubit()..getWeatherData()..loadPlants(),
        ),
        BlocProvider(
          create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
        ),

        BlocProvider(
          create: (BuildContext context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => DetectionCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => CommunityCubit(),
        ),
      ],
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
            locale: Locale(cubit.currentLanguage),
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
