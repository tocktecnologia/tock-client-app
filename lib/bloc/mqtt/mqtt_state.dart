part of 'mqtt_bloc.dart';

@immutable
abstract class MqttState {}

class MqttInitial extends MqttState {}

class ConnectingMqttState extends MqttState {}

class ConnectedMqttState extends MqttState {}

class ConnectionErrorMqttState extends MqttState {
  final mesage;
  final type;
  ConnectionErrorMqttState({required this.mesage, this.type});
}

class UpdatingLightsFromShadowState extends MqttState {}

class UpdatingDeviceFromTockState extends MqttState {}

class UpdatingLightsFromNodeCentralState extends MqttState {}

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

// class UpdateErrorLighState extends MqttState {}
