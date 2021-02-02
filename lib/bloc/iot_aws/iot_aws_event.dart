part of 'iot_aws_bloc.dart';

@immutable
abstract class IotAwsEvent {}

class ConnectIotAwsEvent extends IotAwsEvent {}

class UpdateLightsFromShadowEvent extends IotAwsEvent {
  final statesJson;
  final List<Light> lights;
  UpdateLightsFromShadowEvent(
      {@required this.lights, @required this.statesJson});
}

class UpdateLightsFromNodeCentralEvent extends IotAwsEvent {
  final statesJson;
  final List<Light> lights;
  UpdateLightsFromNodeCentralEvent(
      {@required this.lights, @required this.statesJson});
}

class GetUpdateLightsFromShadowEvent extends IotAwsEvent {}

class GetUpdateLightsFromNodeCentralEvent extends IotAwsEvent {}

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
