part of 'lights_bloc.dart';

@immutable
abstract class LightsState {}

class LightsInitial extends LightsState {}

class LoadingLightStates extends LightsState {}

class LoadedLightStates extends LightsState {}

class LoadLightStatesError extends LightsState {
  final message;
  LoadLightStatesError({@required this.message});
}
