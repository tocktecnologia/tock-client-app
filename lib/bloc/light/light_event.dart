part of 'light_bloc.dart';

@immutable
abstract class LightEvent {}

class ReceiveUpdateLightEvent extends LightEvent {
  final state;
  final deviceId;
  final pin;
  ReceiveUpdateLightEvent({this.state, this.deviceId, this.pin});
}
