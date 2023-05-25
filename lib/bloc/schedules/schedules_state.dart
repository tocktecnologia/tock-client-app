part of 'schedules_cubit.dart';

abstract class SchedulesState {}

class SchedulesInitial extends SchedulesState {}

class UpdatedSchedulesState extends SchedulesState {
  final List<Schedule>? schedules;
  UpdatedSchedulesState({this.schedules});
}
