import 'dart:async';
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/services/mqtt/mqtt_device.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:client/shared/utils/secrets.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:uuid/uuid.dart';

class MqttService {
  MQttDevice? _awsClient;
  MQttDevice? get awsClient => _awsClient;
  String? userIdentityId;
  final StreamController<String> _controller = StreamController<String>();
  StreamController<String> get controller => _controller;

  void init(host,
      {accessKeyId, secretAccessKey, sessionToken, required userIdentityId}) {
    _awsClient = MQttDevice(
      AwsIoTSecrets.awsIotRegion,
      accessKeyId,
      secretAccessKey,
      sessionToken,
      host,
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      logging: false,
    );
    this.userIdentityId = userIdentityId;
  }

  void disconnect() {
    _awsClient?.disconnect();
  }

  void onConnected() {
    print("client Connected!");
  }

  void onDisconnected() {
    print("client Disconected!");
  }

  Future connect() async {
    await _awsClient?.connect(userIdentityId!);
  }

  Future publishJson(message, String topic) async {
    String msg = jsonEncode(message);
    _awsClient?.publishMessage(topic, msg);
  }

  Future suibscribe(String topic) async {
    _awsClient?.subscribe(topic);
  }

  bool isConnected() {
    return _awsClient?.connectionStatus == MqttConnectionState.connected;
  }
}
