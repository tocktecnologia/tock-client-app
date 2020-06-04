part of 'central_bloc.dart';

@immutable
abstract class CentralState {}

class CentralInitial extends CentralState {}

class UpdatingLightsFromCentralState extends CentralState {}

class UpdatedLightsFromCentralState extends CentralState {
  final List<Light> lights;

  UpdatedLightsFromCentralState({this.lights});
}

class UpdateLightsFromCentralErrorState extends CentralState {
  final message;
  UpdateLightsFromCentralErrorState({this.message});
}
