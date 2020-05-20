import 'dart:io';
import 'package:flutter_cognito_plugin/exceptions.dart';

class HandleExptions {
  static String message(e) {
    if (e.runtimeType == NotAuthorizedException) {
      return 'Erro on Authorization, verify if you login and password are correct. ';
    } else if (e.runtimeType == SocketException) {
      return 'Verify your connection please.';
    } else if (e.runtimeType == CognitoException) {
      return 'Exception from Cognito.';
    } else if (e.runtimeType == UsernameExistsException) {
      return 'This user already exist.';
    } else if (e.runtimeType == CodeMismatchException) {
      return 'Wrong code, verify your email.';
    } else if (e.runtimeType == SocketTimeoutException) {
      return 'Time out achieved, try again later.';
    } else
      return 'Error Unknownm $e';
  }
}
