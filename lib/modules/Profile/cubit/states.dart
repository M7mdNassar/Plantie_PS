

import '../../../models/user/user_model.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileImagePickLoadingState extends ProfileStates {}

class ProfileImagePickSuccessState extends ProfileStates {}

class ProfileImagePickCancelledState extends ProfileStates {}

class ProfileImagePickErrorState extends ProfileStates {
  final String error;
  ProfileImagePickErrorState(this.error);
}

class ProfileUpdateLoadingState extends ProfileStates {}

class ProfileImageUpdateLoadingState extends ProfileStates {}


class ProfileUpdateSuccessState extends ProfileStates {
  final UserModel? user;
  ProfileUpdateSuccessState(this.user);
}

class ProfileUpdateErrorState extends ProfileStates {
  final String error;
  ProfileUpdateErrorState(this.error);
}



class ProfileImageUpdateSuccessState extends ProfileStates {}

class ProfileImageUpdateErrorState extends ProfileStates {
  final String error;
  ProfileImageUpdateErrorState(this.error);
}

class ProfileImageClearedState extends ProfileStates{}

class ProfileImageSavedState extends ProfileStates{}

class ProfileImageButtonsUpdateState extends ProfileStates{}