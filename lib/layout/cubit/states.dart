abstract class AppStates {}

final class AppInitialState extends AppStates {}

final class AppChangeNavBottomBarState extends AppStates {}

final class AppChangeModeState extends AppStates {}

class AppGetLoadingState extends AppStates {}

class GetUserLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;

  GetUserErrorState(this.error);
}
