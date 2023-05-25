abstract class AuthState {}

class LoadingLogoutState extends AuthState {}

class LoadingLoginState extends AuthState {}

class ForcingLoginState extends AuthState {}

class LoggedOutState extends AuthState {
  final String? message;
  LoggedOutState({this.message});
}

class LoggedState extends AuthState {
  LoggedState();
}

class LoadingSignUpState extends AuthState {}

class LoadedSignUpState extends AuthState {}

class LoadingForgotPasswordState extends AuthState {}

class LoadedForgotPasswordState extends AuthState {}

class LoadingSendCodeState extends AuthState {}

class LoadedSendCodeState extends AuthState {}

class LoadingConfirmSignUpState extends AuthState {}

class LoadedConfirmSignUpState extends AuthState {}

class LoadingSendCodeConfirmSignUpState extends AuthState {}

class LoadedSendCodeConfirmSignUpState extends AuthState {}

class LoginErrorState extends AuthState {
  final String message;
  final Type? type;

  LoginErrorState({required this.message, this.type});
}
