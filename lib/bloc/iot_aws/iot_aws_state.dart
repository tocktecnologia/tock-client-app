part of 'iot_aws_bloc.dart';

@immutable
abstract class IotAwsState {}

class IotAwsInitial extends IotAwsState {}

class ConnectingIotAwsState extends IotAwsState {}

class ConnectedIotAwsState extends IotAwsState {}

class ConnectionErrorIotAwsState extends IotAwsState {
  final mesage;
  final type;
  ConnectionErrorIotAwsState({this.mesage, this.type});
}

class UpdatingLightsFromShadowState extends IotAwsState {}

class UpdatingLightsFromNodeCentralState extends IotAwsState {}

class UpdatedLightsFromNodeCentralState extends IotAwsState {
  final List<Light> lights;
  UpdatedLightsFromNodeCentralState({this.lights});
}

class UpdatedLightsFromShadowState extends IotAwsState {
  final List<Light> lights;
  UpdatedLightsFromShadowState({this.lights});
}

// class GettingLighState extends IotAwsState {
//   final state;
//   final deviceId;
//   final pin;
//   GettingLighState({this.state, this.deviceId, this.pin});
// }

// class GettedLighState extends IotAwsState {
//   final state;
//   final deviceId;
//   final pin;
//   GettedLighState({this.state, this.deviceId, this.pin});
// }

// class UpdateErrorLighState extends IotAwsState {}
