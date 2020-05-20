part of 'lights_bloc.dart';

@immutable
abstract class LightsEvent {}

class GetStatesLight extends LightsEvent {}

class UpdateDevicesFromAwsEvent extends LightsEvent {
  final devices;
  UpdateDevicesFromAwsEvent({@required this.devices});
}

class UpdateIdxLightsEvent extends LightsEvent {
  final oldIndex;
  final newIndex;
  UpdateIdxLightsEvent({@required this.oldIndex, @required this.newIndex});
}

// class TouchLightEvent extends LightsEvent {
//   final Light light;
//   TouchLightEvent({@required this.light});
// }

class ChangeConfigsLightEvent extends LightsEvent {
  final Light light;
  ChangeConfigsLightEvent({@required this.light});
}

class ReceiveStateLightEvent extends LightsEvent {
  final state;
  final deviceId;
  final pin;
  ReceiveStateLightEvent({this.state, this.deviceId, this.pin});
}
