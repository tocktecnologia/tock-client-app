import 'package:flutter/widgets.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String login;
  final String password;

  LoginEvent({required this.login, required this.password});
}

class ForceLoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final login;
  final password;
  final jsonAttrs;

  SignUpEvent(
      {required this.login, required this.password, required this.jsonAttrs});
}

class ForgotPasswordEvent extends AuthEvent {
  final email;
  final newPassowrd;
  final confirmationCode;
  ForgotPasswordEvent(
      {required this.email,
      required this.newPassowrd,
      required this.confirmationCode});
}

class SendCodeForgotPasswordEvent extends AuthEvent {
  final email;
  SendCodeForgotPasswordEvent({this.email});
}

class SendCodeConfirmSignUpEvent extends AuthEvent {
  final email;
  SendCodeConfirmSignUpEvent({this.email});
}

class ConfirmSignUpEvent extends AuthEvent {
  final email;
  final confirmationCode;

  ConfirmSignUpEvent({required this.email, required this.confirmationCode});
}
