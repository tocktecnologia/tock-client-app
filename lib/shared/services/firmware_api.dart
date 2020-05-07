import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:http/http.dart';

class FirmwareApi {
  String username = 'tock';
  String password = 'tocktecnologia30130';
  String idTest = '10';

  Future isDeviceConnected() async {
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

  Future<Map> getStates() async {
    final url = '${Endpoints.NetAddress}.$idTest:80/tock/states';
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
        return {"response": "sucesso", "retorno": json.decode(response.body)};
      } else {
        return {"response": "falha"};
      }
    } on TimeoutException catch (_) {
      return {"response": "timeout"};
    } on SocketException catch (_) {
      return {"response": "no-internet"};
    }
  }
}
