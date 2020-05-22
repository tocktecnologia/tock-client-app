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
