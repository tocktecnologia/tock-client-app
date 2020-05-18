part of 'lights_bloc.dart';

@immutable
abstract class LightsState {}

class LightsInitial extends LightsState {}

class LoadingLightStates extends LightsState {}

class LoadedLightStates extends LightsState {
  final List<Light> lights;
  LoadedLightStates({@required this.lights});
}

class LoadLightStatesError extends LightsState {
  final message;
  LoadLightStatesError({@required this.message});
}

class UpdatingLightState extends LightsState {
  final Light light;
  UpdatingLightState({@required this.light});
}

class UpdatedLightState extends LightsState {
  final Light light;
  UpdatedLightState({@required this.light});
}

class UpdatLightsStateError extends LightsState {}
