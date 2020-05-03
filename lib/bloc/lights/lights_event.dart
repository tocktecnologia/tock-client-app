part of 'lights_bloc.dart';

@immutable
abstract class LightsEvent {}

class GetStateLight extends LightsEvent {
  final lightId;
  GetStateLight({@required this.lightId});
}
