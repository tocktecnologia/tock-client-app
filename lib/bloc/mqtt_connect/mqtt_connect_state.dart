part of 'mqtt_connect_bloc.dart';

abstract class MqttConnectState {}

class MqttConnectInitial extends MqttConnectState {}

class ConnectingMqttState extends MqttConnectState {}

class ConnectedMqttState extends MqttConnectState {
  final List<String> thingIdList;
  ConnectedMqttState(this.thingIdList);
}

class DisonnectedMqttState extends MqttConnectState {}

class ConnectionErrorMqttState extends MqttConnectState {
  final String mesage;
  final Type? type;
  ConnectionErrorMqttState({required this.mesage, this.type});
}

class UpdatingLightsFromShadowState extends MqttConnectState {}

class UpdatingDeviceFromTockState extends MqttConnectState {}

class UpdatingLightsFromNodeCentralState extends MqttConnectState {}

// class UpdatedLightsFromNodeCentralState extends MqttState {
//   final List<Light> lights;
//   UpdatedLightsFromNodeCentralState({this.lights});
// }

// class UpdatedLightsFromShadowState extends MqttState {
//   final List<Light> lights;
//   UpdatedLightsFromShadowState({this.lights});
// }

// class GettingLighState extends MqttState {
//   final state;
//   final deviceId;
//   final pin;
//   GettingLighState({this.state, this.deviceId, this.pin});
// }

// class GettedLighState extends MqttState {
//   final state;
//   final deviceId;
//   final pin;
//   GettedLighState({this.state, this.deviceId, this.pin});
// }

// class UpdateErrorLighState extends MqttConnectionState {}
