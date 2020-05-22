part of 'iot_aws_bloc.dart';

@immutable
abstract class IotAwsEvent {}

class ConnectIotAwsEvent extends IotAwsEvent {}

// class ReceiveUpdateIotAwsEvent extends IotAwsEvent {
//   final state;
//   final deviceId;
//   final pin;
//   ReceiveUpdateIotAwsEvent({this.state, this.deviceId, this.pin});
// }

// class GetUpdateIotAwsEvent extends IotAwsEvent {
//   final state;
//   final deviceId;
//   final pin;
//   GetUpdateIotAwsEvent({this.state, this.deviceId, this.pin});
// }
