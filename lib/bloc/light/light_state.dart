part of 'light_bloc.dart';

@immutable
abstract class LightState {}

class LightInitial extends LightState {}

class UpdatingLighState extends LightState {
  final state;
  final deviceId;
  final pin;
  UpdatingLighState({this.state, this.deviceId, this.pin});
}

class UpdatedLighState extends LightState {
  final state;
  final deviceId;
  final pin;
  UpdatedLighState({this.state, this.deviceId, this.pin});
}

class UpdateErrorLighState extends LightState {}
