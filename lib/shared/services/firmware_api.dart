import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:http/http.dart';

class FirmwareApi {
  String username = 'tock';
  String password = 'tocktecnologia30130';
  String idTest = '10';

  Future isDeviceConnected() async {
    final url = 'http://10.0.1.10:80/tock';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final headers = {
      'authorization': basicAuth,
      'content-type': 'application/json'
    };

    try {
      final response =
          await post(url, headers: headers).timeout(Duration(seconds: 3));
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
    final url = 'http://10.0.1.10:80/tock/update';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final headers = {
      'authorization': basicAuth,
      'content-type': 'application/json'
    };

    final body = {"estados": "001,120"};

    try {
      final response =
          await post(url, headers: headers, body: json.encode(body))
              .timeout(Duration(seconds: 4));
      if (response.statusCode == 200) {
        return json.decode(response.body);
        //return {"status": "sucesso", "message": json.decode(response.body)};
      } else {
        return {"status": "falha"};
      }
    } on TimeoutException catch (_) {
      return {"status": "falha", "message": "timeout"};
    } on SocketException catch (_) {
      return {
        "status": "falha",
        "message": "Central Tock não encontrada na rede local."
      };
    } catch (e) {
      return {"status": "falha", "message": e.runtimeType};
    }
  }

  Future<bool> updateState({@required Light light, @required newState}) async {
    final url = 'http://10.0.1.10:80/tock/update';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final headers = {
      'authorization': basicAuth,
      'content-type': 'application/json'
    };
    final body = {"pin${light.device.pin}": newState};

    try {
      final response =
          await post(url, headers: headers, body: json.encode(body))
              .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        return false; //{"status": "falha"};
      }
    } on TimeoutException catch (_) {
      return false; //{"status": "falha", "message": "timeout"};
    } on SocketException catch (_) {
      return false; //{"status": "falha", "message": "no-internet"};
    } catch (e) {
      return false; // {"status": "falha", "message": e.toString()};
    }
  }
}
