part of 'lights_bloc.dart';

@immutable
abstract class LightsEvent {}

class UpdateLightsFromCentralEvent extends LightsEvent {
  final statesJson;
  UpdateLightsFromCentralEvent({this.statesJson});
}

// class UpdateLightsFromShadowEvent extends LightsEvent {
//   final statesJson;
//   UpdateLightsFromShadowEvent({this.statesJson});
// }

// class GetUpdateLightsFromCentralEvent extends LightsEvent {}

class ReconnectAwsIotEvent extends LightsEvent {}

class UpdateDevicesFromAwsAPIEvent extends LightsEvent {
  final devices;
  UpdateDevicesFromAwsAPIEvent({@required this.devices});
}

class UpdateIdxLightsEvent extends LightsEvent {
  final oldIndex;
  final newIndex;
  UpdateIdxLightsEvent({@required this.oldIndex, @required this.newIndex});
}

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

class GoToUpdatedLightsFromCentralState extends LightsEvent {}
