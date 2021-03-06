part of 'lights_bloc.dart';

@immutable
abstract class LightsState {}

class LightsInitial extends LightsState {}

class UpdatingDevicesFromAwsState extends LightsState {}

class UpdatedDevicesFromAwsState extends LightsState {
  final List<Light> lights;
  UpdatedDevicesFromAwsState({this.lights});
}

class UpdatingDevicesState extends LightsState {}

class UpdatedDevicesState extends LightsState {
  final List<Light> lights;
  UpdatedDevicesState({@required this.lights});
}

//
class UpdatedLightsFromCentralState extends LightsState {
  final List<Light> lights;
  UpdatedLightsFromCentralState({@required this.lights});
}

class UpdatedLightConfigsState extends LightsState {
  final List<Light> lights;
  UpdatedLightConfigsState({@required this.lights});
}

class UpdatingLightState extends LightsState {
  final state;
  final deviceId;
  final pin;
  UpdatingLightState({this.state, this.deviceId, this.pin});
}

class UpdatedLightState extends LightsState {
  final List<Light> lights;
  UpdatedLightState({@required this.lights});
}

class LoadingLightStates extends LightsState {}

class LoadedLightStates extends LightsState {
  final List<Light> lights;
  LoadedLightStates({@required this.lights});
}

class LoadLightStatesError extends LightsState {
  final message;
  LoadLightStatesError({@required this.message});
}

class ReorderedLightStates extends LightsState {
  final List<Light> lights;
  ReorderedLightStates({@required this.lights});
}

class LightStatesError extends LightsState {
  final message;
  LightStatesError({this.message});
}
