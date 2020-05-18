part of 'lights_bloc.dart';

@immutable
abstract class LightsEvent {}

class GetStatesLight extends LightsEvent {}

class UpdateLightConfigsEvent extends LightsEvent {
  final userDevices;
  UpdateLightConfigsEvent({@required this.userDevices});
}

class UpdateIdxLightsEvent extends LightsEvent {
  final oldIndex;
  final newIndex;
  UpdateIdxLightsEvent({@required this.oldIndex, @required this.newIndex});
}

class TouchLightEvent extends LightsEvent {
  final Light light;
  TouchLightEvent({@required this.light});
}
