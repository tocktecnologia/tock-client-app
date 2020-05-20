part of 'schedules_bloc.dart';

@immutable
abstract class SchedulesState {}

class SchedulesInitial extends SchedulesState {}

class UpdatingSchedulesState extends SchedulesState {}

class UpdatedSchedulesState extends SchedulesState {
  final List<Schedule> schedules;
  UpdatedSchedulesState({this.schedules});
}

class UpdatSchedulesErrorState extends SchedulesState {
  final message;
  UpdatSchedulesErrorState({this.message});
}
