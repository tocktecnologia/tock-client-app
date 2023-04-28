import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'server.dart' if (dart.library.html) 'browser.dart' as mqttsetup;

class MQttDevice {
  final _SERVICE_NAME = 'iotdevicegateway';
  final _AWS4_REQUEST = 'aws4_request';
  final _AWS4_HMAC_SHA256 = 'AWS4-HMAC-SHA256';
  final _SCHEME = 'wss://';

  String? _region;
  String? _accessKeyId;
  String? _secretAccessKey;
  String? _sessionToken;
  String? _host;
  bool? _logging;

  var _onConnected;
  var _onDisconnected;
  var _onSubscribed;
  var _onSubscribeFail;
  var _onUnsubscribed;
  Function? _messageReceive;

  set messageReceive(val) => _messageReceive = val;

  get onConnected => _onConnected;
  set onConnected(val) => _client?.onConnected = _onConnected = val;
  get onDisconnected => _onDisconnected;
  set onDisconnected(val) => _client?.onDisconnected = _onDisconnected = val;
  get onSubscribed => _onSubscribed;
  set onSubscribed(val) => _client?.onSubscribed = _onSubscribed = val;
  get onSubscribeFail => _onSubscribeFail;
  set onSubscribeFail(val) => _client?.onSubscribeFail = _onSubscribeFail = val;
  get onUnsubscribed => _onUnsubscribed;
  set onUnsubscribed(val) => _client?.onUnsubscribed = _onUnsubscribed = val;
  get connectionStatus => _client?.connectionStatus;

  MqttClient? _client;
  MqttClient? get client => _client;

  final StreamController<Tuple2<String, String>> _messagesController =
      StreamController<Tuple2<String, String>>();
  Stream<Tuple2<String, String>> get messages => _messagesController.stream;

  StreamController<String> controller = StreamController<String>();

  MQttDevice(this._region, this._accessKeyId, this._secretAccessKey,
      this._sessionToken, String host,
      {bool logging = true,
      var onConnected,
      var onDisconnected,
      var onSubscribed,
      var onSubscribeFail,
      var onUnsubscribed,
      var onMessageReceive}) {
    _logging = logging;
    _onConnected = onConnected;
    _onDisconnected = onDisconnected;
    _onSubscribed = onSubscribed;
    _onSubscribeFail = onSubscribeFail;
    _onUnsubscribed = onUnsubscribed;

    if (host.contains('amazonaws.com')) {
      _host = host.split('.').first;
    } else {
      _host = host;
    }
  }

  Future<void> connect(String clientId) async {
    if (_client == null) {
      _prepare(clientId);
    }

    /// Check we are connected
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      // print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      // print(
      //     'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client?.connectionStatus}');
      _client?.disconnect();

      try {
        await _client?.connect();
      } on Exception catch (_) {
        _client?.disconnect();
        rethrow;
      }
    }

    // _client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   for (MqttReceivedMessage<MqttMessage> message in c) {
    //     final MqttPublishMessage recMess =
    //         message.payload as MqttPublishMessage;
    //     final String pt =
    //         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    //     // _messagesController.sink.add(Tuple2<String, String>(message.topic, pt));

    //     _messagesController.add(Tuple2<String, String>(message.topic, pt));

    //     print("pt: $pt");
    //   }
    // });
  }

  _prepare(clientId) {
    if (_host == MqttSecrets.localHost) {
      _prepareMosquitto(clientId);
    } else if (_host == MqttSecrets.awsHost) {
      _prepareAws(clientId);
    }

    _client?.logging(on: _logging == true);
    _client?.autoReconnect = true;
  }

  _prepareAws(String clientId) {
    final url = _prepareWebSocketUrl();
    _client = mqttsetup.setup(url, clientId, 443);
    _client?.port = 443;
    _client?.keepAlivePeriod = 300;
    if (!kIsWeb) {
      (_client as MqttServerClient).useWebSocket = true;
    }
  }

  _prepareMosquitto(clientId) {
    _client = kIsWeb
        ? mqttsetup.setup('ws://192.168.0.6', clientId, 8008)
        : mqttsetup.setup('192.168.0.6', clientId, 1883);
    _client?.keepAlivePeriod = 30;

    _client?.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  }

  _prepareWebSocketUrl() {
    final now = _generateDatetime();
    final hostname = _buildHostname();

    final List credentials = [
      _accessKeyId,
      _getDate(now),
      _region,
      _SERVICE_NAME,
      _AWS4_REQUEST,
    ];

    const payload = '';

    const path = '/mqtt';

    final queryParams = Map<String, String>.from({
      'X-Amz-Algorithm': _AWS4_HMAC_SHA256,
      'X-Amz-Credential': credentials.join('/'),
      'X-Amz-Date': now,
      'X-Amz-SignedHeaders': 'host',
      'X-Amz-Expire': '86400',
    });

    final canonicalQueryString = SigV4.buildCanonicalQueryString(queryParams);
    final request = SigV4.buildCanonicalRequest(
        'GET',
        path,
        queryParams,
        Map.from({
          'host': hostname,
        }),
        payload);

    final hashedCanonicalRequest = SigV4.hashCanonicalRequest(request);
    final stringToSign = SigV4.buildStringToSign(
        now,
        SigV4.buildCredentialScope(now, _region!, _SERVICE_NAME),
        hashedCanonicalRequest);

    final signingKey = SigV4.calculateSigningKey(
        _secretAccessKey!, now, _region!, _SERVICE_NAME);

    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    final finalParams =
        '$canonicalQueryString&X-Amz-Signature=$signature&X-Amz-Security-Token=${Uri.encodeComponent(_sessionToken!)}';

    return '$_SCHEME$hostname$path?$finalParams';
  }

  String _generateDatetime() {
    return DateTime.now()
        .toUtc()
        .toString()
        .replaceAll(RegExp(r'\.\d*Z$'), 'Z')
        .replaceAll(RegExp(r'[:-]|\.\d{3}'), '')
        .split(' ')
        .join('T');
  }

  String _getDate(String dateTime) {
    return dateTime.substring(0, 8);
  }

  String _buildHostname() {
    return '$_host.iot.$_region.amazonaws.com';
  }

  void disconnect() {
    return _client?.disconnect();
  }

  Subscription? subscribe(String topic,
      [MqttQos qosLevel = MqttQos.atLeastOnce]) {
    /// Check we are connected
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      print("Subscribing to topic '$topic'");
      return _client?.subscribe(topic, qosLevel);
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client?.connectionStatus}');
      _client?.disconnect();
      return null;
    }
  }

  void publishMessage(String topic, String payload) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client?.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  // void publishJson(String message, {required dynamic topic}) {
  //   print("tryig pub msg $message on topic $topic");
  //   final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  //   builder.addString(message);
  //   _client?.publishMessage(
  //       jsonEncode(topic), MqttQos.atMostOnce, builder.payload!);
  // }
}
