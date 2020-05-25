part of 'schedules_bloc.dart';

@immutable
abstract class SchedulesState {}

class SchedulesInitial extends SchedulesState {}

class UpdatingSchedulesState extends SchedulesState {}

class UpdatedSchedulesState extends SchedulesState {
  final List<Schedule> schedules;
  UpdatedSchedulesState({this.schedules});
}

class UpdateSchedulesErrorState extends SchedulesState {
  final message;
  UpdateSchedulesErrorState({this.message});
}

class UpdatingScheduleActionState extends SchedulesState {}

class UpdatedScheduleActionState extends SchedulesState {}

class DeletingScheduleState extends SchedulesState {
  final Schedule schedule;

  DeletingScheduleState({this.schedule});
}

class DeletedScheduleState extends SchedulesState {}

class EnablingScheduleState extends SchedulesState {
  final Schedule schedule;
  EnablingScheduleState({this.schedule});
}

class EnabledScheduleState extends SchedulesState {}
