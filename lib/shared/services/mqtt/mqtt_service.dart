import 'dart:async';
import 'dart:convert';
import 'dart:math';

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
  String? sessionToken;

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
      logging: false,
    );
    this.userIdentityId = userIdentityId;
    this.sessionToken = sessionToken;
  }

  void disconnect() {
    _awsClient?.disconnect();
  }

  Future<MqttClientConnectionStatus?> connect() async {
    final start = (sessionToken?.length)! - 8;
    final id = "$userIdentityId-${sessionToken?.substring(start)}";
    print("connecting with id: $id ...");

    return await _awsClient?.connect(id);
  }

  Future publishJson(message, String topic) async {
    String msg = jsonEncode(message);

    if (isConnected()) {
      _awsClient?.publishMessage(topic, msg);
    } else {
      print("client not connected!");
      connect();
    }
  }

  Future<Subscription?> suibscribe(String topic) async {
    if (isConnected()) {
      return _awsClient?.subscribe(topic);
    }

    print("client not connected!");
    connect();
    return null;
  }

  bool isConnected() {
    return _awsClient?.connectionStatus.state == MqttConnectionState.connected;
  }

  void getShadow(thingId) {
    print("publishing to ${MqttTopics.topicShadowGet(thingId)}");
    publishJson({}, MqttTopics.topicShadowGet(thingId));
  }
}
