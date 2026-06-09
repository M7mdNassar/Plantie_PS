import '../../../models/user/user_model.dart';

abstract class ProfileStates {}

/// Initial / generic rebuild state
class ProfileInitialState extends ProfileStates {}

/// Emitted whenever any UI-visible property changes (flags, picked image, fields).
/// The screen reads boolean flags from the cubit to determine what to show.
class ProfileChangedState extends ProfileStates {}

/// Emitted on successful profile update (avatar or fields).
/// Handled by BlocListener to show a success notification.
class ProfileUpdateSuccessState extends ProfileStates {
  final UserModel? user;
  ProfileUpdateSuccessState(this.user);
}

/// Emitted on any error. Handled by BlocListener to show an error notification.
class ProfileUpdateErrorState extends ProfileStates {
  final String error;
  ProfileUpdateErrorState(this.error);
}
