import 'dart:convert';

import 'package:client/shared/services/mqtt/mqtt_device.dart';
import 'package:client/shared/utils/secrets.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:uuid/uuid.dart';

class MqttService {
  MQttDevice? _awsClient;
  MQttDevice? get awsClient => _awsClient;

  void init(host, {accessKeyId, secretAccessKey, sessionToken}) {
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
  }

  void onConnected() {
    print("client Connected!");
    suibscribe("tock-commands");
  }

  void onDisconnected() {
    print("client Disconected!");
  }

  Future connect() async {
    await _awsClient?.connect(const Uuid().v1());
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
