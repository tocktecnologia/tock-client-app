import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/src/cognito_user_exceptions.dart';

import 'package:client/shared/utils/exceptions_tock.dart';

class HandleExptions {
  static String message(e) {
    if (e.runtimeType == CognitoUserException) {
      return 'Exception from User Cognito.';
    } else if (e.runtimeType == SocketException) {
      return 'Verifique sua conexão com a internet.';
      // } else if (e.runtimeType == UsernameExistsException) {
      //   return 'Esse usuário já existe';
      // } else if (e.runtimeType == CodeMismatchException) {
      //   return 'Senha e email não compatíveis';
    } else if (e.runtimeType == IotAwsException) {
      return 'Não foi possível conectar com seus dispositivos. Verifique sua conexão ou contacte um paceiro Tock de sua região';
    } else
      return 'Error Unknownm $e';
  }
}
