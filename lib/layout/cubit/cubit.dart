import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/layout/cubit/states.dart';
import '../../modules/Community/community_screen.dart';
import '../../modules/Detection/Classification/image_picker_handler.dart';
import '../../modules/Detection/detection_screen.dart';
import '../../modules/Home/home_screen.dart';
import '../../modules/Profile/profile_screen.dart';
import '../../shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState()) {
    _loadSavedLanguage();
  }

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  final List<IconData> iconList = [
    Icons.eco_outlined,
    Icons.forum_outlined,
    Icons.photo_camera_back_outlined,
    Icons.person_outlined,
  ];

  // PERF_FIX: Lazy initialization of screens to reduce memory footprint
  // Instead of creating all screens upfront, create on-demand
  late final Map<int, Widget> _screenCache = {};

  Widget get homeScreen => _screenCache.putIfAbsent(0, () => const HomeScreen());
  Widget get communityScreen => _screenCache.putIfAbsent(1, () => const CommunityScreen());
  Widget get detectionScreen => _screenCache.putIfAbsent(2, () => const DetectionScreen());
  Widget get profileScreen => _screenCache.putIfAbsent(3, () => const ProfileScreen());

  List<Widget> get screens => [
    homeScreen,
    communityScreen,
    detectionScreen,
    profileScreen,
  ];

  void changeIndex(int index) {
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

  void startClassification(BuildContext context) {
    emit(FloatActionButtonPressed());
    ImagePickerHandler.processImage(context);
  }

  String currentLanguage = 'ar';
  bool get isArabic => currentLanguage == 'ar';

  Future<void> changeLanguage(String langCode) async {
    currentLanguage = langCode;
    await CacheHelper.saveData(key: 'language', value: langCode);
    emit(LanguageChangedState(langCode));
  }

  // Load saved language - use Future not async void
  Future<void> _loadSavedLanguage() async {
    try {
      currentLanguage = CacheHelper.getData(key: 'language') ?? 'ar';
      emit(LanguageChangedState(currentLanguage));
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  @override
  Future<void> close() {
    // Cleanup if needed
    return super.close();
  }
}
