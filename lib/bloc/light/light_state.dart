part of 'light_bloc.dart';

@immutable
abstract class LightState {}

class LightInitial extends LightState {}

class GettingLighState extends LightState {
  final state;
  final deviceId;
  final pin;
  GettingLighState({this.state, this.deviceId, this.pin});
}

class GettedLighState extends LightState {
  final state;
  final deviceId;
  final pin;
  GettedLighState({this.state, this.deviceId, this.pin});
}
