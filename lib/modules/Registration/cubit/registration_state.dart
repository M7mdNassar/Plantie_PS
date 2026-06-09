import 'package:plantie/models/user/user_model.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final UserModel user;

  RegistrationSuccess(this.user);
}

class RegistrationError extends RegistrationState {
  final String message;

  RegistrationError(this.message);
}

