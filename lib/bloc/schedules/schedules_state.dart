part of 'schedules_cubit.dart';

abstract class SchedulesState {}

class SchedulesInitial extends SchedulesState {}

class UpdatingSchedulesState extends SchedulesState {}

class UpdatedSchedulesState extends SchedulesState {
  final List<Schedule>? schedules;
  UpdatedSchedulesState({this.schedules});
}

class UpdateSchedulesErrorState extends SchedulesState {
  final String message;
  UpdateSchedulesErrorState({required this.message});
}

class UpdatingScheduleActionState extends SchedulesState {}

class UpdatedScheduleActionState extends SchedulesState {}

class DeletingScheduleState extends SchedulesState {
  final Schedule schedule;
  DeletingScheduleState({required this.schedule});
}

class DeletedScheduleState extends SchedulesState {}

class EnablingScheduleState extends SchedulesState {
  final Schedule schedule;
  EnablingScheduleState({required this.schedule});
}

class EnabledScheduleState extends SchedulesState {}

class ExecutingScheduleActionsState extends SchedulesState {}
