
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/layout/cubit/states.dart';
import '../../modules/Community/community_screen.dart';
import '../../modules/Detection/detection_screen.dart';
import '../../modules/Home/home_screen.dart';
import '../../modules/Profile/profile_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = [
    "Home",
    "Community",
    "Detection",
    "Profile",
  ];
  final List<IconData> iconList = [
    Icons.home,
    Icons.people,
    Icons.real_estate_agent_sharp,
    Icons.person,
  ];
  List<Widget> screens = [
    HomeScreen(),
    CommunityScreen(),
    DetectionScreen(),
    ProfileScreen(),
  ];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeNavBottomBarState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }




  void resendVerificationEmail() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((_) {
      showToast(
        text: "Verification email resent. Please check your inbox.",
        state: ToastStates.SUCCESS,
      );
    }).catchError((error) {
      showToast(
        text: error.toString(),
        state: ToastStates.ERROR,
      );
    });
  }

}