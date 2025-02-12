import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/layout/cubit/states.dart';
import '../../modules/Community/community_screen.dart';
import '../../modules/Detection/Classification/image_picker_handler.dart';
import '../../modules/Detection/detection_screen.dart';
import '../../modules/Home/home_screen.dart';
import '../../modules/Profile/profile_screen.dart';
import '../../shared/network/local/cache_helper.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState()){
    _loadSavedLanguage();
  }

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = [
    "Home",
    "Community",
    "Detection",
    "Profile",
  ];
  final List<IconData> iconList = [
    Icons.eco_outlined,
    Icons.forum_outlined,
    Icons.photo_camera_back_outlined,
    Icons.person_outlined,
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


  void startClassification(context){
    emit(FloatActionButtonPressed());
    ImagePickerHandler.processImage(context);
  }

  void resendVerificationEmail() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((_) {
      emit(VerificationEmailSentState());
    }).catchError((error) {
      emit(VerificationEmailErrorState(error.toString()));
    });
  }





  String currentLanguage = 'en';
  bool get isArabic => currentLanguage == 'ar';

  Future<void> changeLanguage(String langCode) async {
    currentLanguage = langCode;
    await CacheHelper.saveData(key: 'language', value: langCode);
    emit(LanguageChangedState(langCode));
  }


  void _loadSavedLanguage() async {
    currentLanguage = CacheHelper.getData(key: 'language') ?? 'en';
    emit(LanguageChangedState(currentLanguage));
  }

}