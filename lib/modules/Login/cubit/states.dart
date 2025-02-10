abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}

class LoginCanceldState extends LoginStates {
  final String msg;

  LoginCanceldState(this.msg);
}

class ChangePasswordVisibilityState extends LoginStates {}

class ResetPasswordLoadingState extends LoginStates {}

class ResetPasswordSuccessState extends LoginStates {}

class ResetPasswordErrorState extends LoginStates {
  final String error;

  ResetPasswordErrorState(this.error);
}
