import 'dart:async';
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:client/shared/utils/handle_exceptions.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

part 'mqtt_connect_state.dart';

class MqttConnectCubit extends Cubit<MqttConnectState> {
  MqttConnectCubit() : super(MqttConnectInitial());

  String _host = MqttSecrets.awsHost;
  get host => _host;
  List<String> thingIdList = <String>[];

  Future<void> mqttConnect(List<Device> devices, {String? host}) async {
    emit(ConnectingMqttState());
    try {
      MqttClientConnectionStatus? connectionStatus;
      _host = host ?? _host;
      CognitoCredentials? credentials =
          await Locator.instance.get<CognitoUserService>().getCredentials();

      // AWS
      if (_host == MqttSecrets.awsHost) {
        Locator.instance.get<MqttService>().init(_host,
            accessKeyId: credentials?.accessKeyId,
            secretAccessKey: credentials?.secretAccessKey,
            sessionToken: credentials?.sessionToken,
            userIdentityId: credentials?.userIdentityId);

        connectionStatus = await Locator.instance.get<MqttService>().connect();

        // subscribing
        final seen = <String>{};
        List<Device> devicesUnique =
            devices.where((device) => seen.add(device.remoteId!)).toList();
        // subscribing updates shadow and get shadow
        for (int i = 0; i < devicesUnique.length; i++) {
          final String thingName = devicesUnique[i].remoteId.toString();
          thingIdList.add(thingName);
          final topicUpdate = MqttTopics.topicShadowUpdateAccepted(thingName);
          final topicGet = MqttTopics.topicShadowGetAccepted(thingName);
          await Locator.instance.get<MqttService>().suibscribe(topicUpdate);
          await Locator.instance.get<MqttService>().suibscribe(topicGet);
        }
        await Locator.instance.get<MqttService>().suibscribe("tock/test");
      }
      // MOSQUITTO
      else {
        Locator.instance
            .get<MqttService>()
            .init(_host, userIdentityId: credentials?.userIdentityId);
        connectionStatus = await Locator.instance.get<MqttService>().connect();
        // await Locator.instance.get<MqttService>().suibscribe("tock-commands");
      }

      await Future.delayed(const Duration(milliseconds: 100));

      emit(connectionStatus?.state == MqttConnectionState.connected
          ? ConnectedMqttState(thingIdList)
          : ConnectionErrorMqttState(mesage: "Can't Connect Mqtt!"));
    } catch (e) {
      print("ConnectionErrorMqttState: ${e.toString()}");
      emit(ConnectionErrorMqttState(
          mesage: HandleExptions.message(e), type: e.runtimeType));
    }
  }

  Future<void> mqttDisconnect() async {
    Locator.instance.get<MqttService>().awsClient?.client?.disconnect();
    emit(DisonnectedMqttState());
  }
}