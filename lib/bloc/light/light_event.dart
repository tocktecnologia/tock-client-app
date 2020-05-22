part of 'light_bloc.dart';

@immutable
abstract class LightEvent {}

class ReceiveUpdateLightEvent extends LightEvent {
  final state;
  final deviceId;
  final pin;
  ReceiveUpdateLightEvent({this.state, this.deviceId, this.pin});
}

class GetUpdateLightEvent extends LightEvent {
  final state;
  final deviceId;
  final pin;
  GetUpdateLightEvent({this.state, this.deviceId, this.pin});
}
