import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/shared/bloc_observer.dart';
import 'package:plantie/shared/components/constants.dart';
import 'package:plantie/shared/network/local/cache_helper.dart';
import 'package:plantie/shared/styles/themes.dart';

import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'models/user/user_model.dart';
import 'modules/OnBoarding/on_boarding_screen.dart';
import 'modules/SplashScreen/lottie_loading_Screen.dart';
import 'modules/WelcomePlantie/welcome_screen.dart';

void main() async {
  // بيتأكد ان كل اشي هون في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  uId = CacheHelper.getData(key: 'uId') ?? "";

  if (uId != "") {
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) {
      CurrentUser.setUser(UserModel.fromJson(doc.data()!));
    }).catchError((error) {
    });
  }

  Widget widget;

  if (onBoarding == true) {
    if(uId != "")
    {
      widget = LottieLoadingScreen();
    } else
    {
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
    required this.isDark,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
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
