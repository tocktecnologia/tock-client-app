import 'dart:async';

import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class UserCognito {
  UserState _userState;
  UserState get userState => _userState;

  Map<String, String> _userAttrs = {"email": "Usuário Local"};
  Map<String, String> get userAttrs => _userAttrs;

  initialize() async {
    try {
      _userState = await Cognito.initialize();
    } catch (e, trace) {
      throw CognitoException(e.toString(), trace.toString());
    }

    Cognito.registerCallback((value) {
      _userState = value;
    });
  }

  Future login(login, password) async {
    try {
      await Cognito.signIn(login, password).timeout(Duration(seconds: 20));
      _userAttrs =
          await Cognito.getUserAttributes().timeout(Duration(seconds: 5));
      return true;
    } catch (e) {
      print('Log ----- catch cognito login: ${e.toString()}');
      return false;
    }
  }

  Future verifyLogin() async {
    try {
      await Cognito.isSignedIn();
      _userAttrs =
          await Cognito.getUserAttributes().timeout(Duration(seconds: 5));
      return true;
    } catch (e) {
      print('Log ----- catch cognito verify login: ${e.toString()}');
      return false;
    }
  }
}
