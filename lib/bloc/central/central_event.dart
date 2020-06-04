part of 'central_bloc.dart';

@immutable
abstract class CentralEvent {}

class GetUpdateLightsFromCentralEvent extends CentralEvent {
  final List<Light> lights;
  GetUpdateLightsFromCentralEvent({@required this.lights});
}
