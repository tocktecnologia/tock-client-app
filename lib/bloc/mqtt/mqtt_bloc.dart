import 'dart:async';
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/utils/handle_exceptions.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:client/shared/utils/secrets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
part 'mqtt_state.dart';

class MqttCubit extends Cubit<MqttState> {
  MqttCubit() : super(MqttInitial());

  String _host = MqttSecrets.awsHost;

  Future<void> changeHost(host) async {
    emit(ConnectingMqttState());
    _host = host;
    await mqttConnect();
  }

  Future<void> mqttConnect() async {
    emit(ConnectingMqttState());
    try {
      if (_host == MqttSecrets.awsHost) {
        CognitoCredentials? credentials =
            await Locator.instance.get<CognitoUserService>().getCredentials();

        Locator.instance.get<MqttService>().init(
              _host,
              accessKeyId: credentials?.accessKeyId,
              secretAccessKey: credentials?.secretAccessKey,
              sessionToken: credentials?.sessionToken,
            );
      } else {
        Locator.instance.get<MqttService>().init(_host);
      }

      await Locator.instance.get<MqttService>().connect();
      dynamic connectionStatus =
          Locator.instance.get<MqttService>().awsClient?.connectionStatus;

      emit(connectionStatus == MqttConnectionState.connected
          ? ConnectedMqttState()
          : ConnectionErrorMqttState(mesage: "Can't Connect"));
    } catch (e) {
      emit(ConnectionErrorMqttState(
          mesage: HandleExptions.message(e), type: e.runtimeType));
    }
  }

  Future<void> mqttPublish(String message, String topic) async {
    emit(UpdatingLightsFromShadowState());
    try {
      String payload = jsonEncode(message);
      Locator.instance
          .get<MqttService>()
          .awsClient
          ?.publishMessage(topic, payload);
    } catch (e) {
      emit(ConnectionErrorMqttState(
          mesage: HandleExptions.message(e), type: e.runtimeType));
    }
  }
}
