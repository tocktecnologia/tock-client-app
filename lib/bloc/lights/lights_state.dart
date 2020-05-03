part of 'lights_bloc.dart';

@immutable
abstract class LightsState {}

class LightsInitial extends LightsState {}

class LoadingLightState extends LightsState {
  final lightId;
  LoadingLightState({@required this.lightId});
}

class LoadedLightState extends LightsState {
  final lightId;
  LoadedLightState({@required this.lightId});
}
