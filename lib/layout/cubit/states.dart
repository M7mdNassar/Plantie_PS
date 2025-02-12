abstract class AppStates {}

final class AppInitialState extends AppStates {}

final class AppChangeNavBottomBarState extends AppStates {}

class AppGetLoadingState extends AppStates {}

class GetUserLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;

  GetUserErrorState(this.error);
}

class AppChangeModeState extends AppStates {}

class FloatActionButtonPressed extends AppStates {}

class VerificationEmailSentState extends AppStates {}

class VerificationEmailErrorState extends AppStates {
  final String error;

  VerificationEmailErrorState(this.error);
}

class LanguageChangedState extends AppStates {
  final String languageCode;
  LanguageChangedState(this.languageCode);
}