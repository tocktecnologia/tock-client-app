import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:http/http.dart';

class FirmwareApi {
  String username = 'tock';
  String password = 'tocktecnologia30130';
  String idTest = '10';

  Future verifyLogin() async {
    final url = '${Endpoints.NetAddress}.$idTest:80/tock';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final headers = {
      'authorization': basicAuth,
      'content-type': 'application/json'
    };

    try {
      final response =
          await post(url, headers: headers).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (_) {
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future getState() async {
    ;
  }
}
