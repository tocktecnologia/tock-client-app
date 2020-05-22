import 'dart:io';
import 'package:flutter_cognito_plugin/exceptions.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_login_setup_cognito/shared/utils/exceptions_tock.dart';

class HandleExptions {
  static String message(e) {
    if (e.runtimeType == NotAuthorizedException) {
      return 'Erro on Authorization, verify if you login and password are correct. ';
    } else if (e.runtimeType == SocketException) {
      return 'Verifique sua conexão com a internet.';
    } else if (e.runtimeType == CognitoException) {
      return 'Exception from Cognito.';
    } else if (e.runtimeType == UsernameExistsException) {
      return 'Esse usuário já existe';
    } else if (e.runtimeType == CodeMismatchException) {
      return 'Senha e email não compatíveis';
    } else if (e.runtimeType == SocketTimeoutException) {
      return 'Time out achieved, try again later.';
    } else if (e.runtimeType == IotAwsException) {
      return 'Não foi possível conectar com seus dispositivos. Verifique sua conexão ou contacte um paceiro Tock informando seu id em Configurações.';
    } else
      return 'Error Unknownm $e';
  }
}
