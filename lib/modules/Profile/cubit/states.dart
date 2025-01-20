

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

class ProfileUpdateSuccessState extends ProfileStates {
  final UserModel? user;
  ProfileUpdateSuccessState(this.user);
}

class ProfileUpdateErrorState extends ProfileStates {
  final String error;
  ProfileUpdateErrorState(this.error);
}
