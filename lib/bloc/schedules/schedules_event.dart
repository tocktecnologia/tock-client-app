part of 'schedules_bloc.dart';

@immutable
abstract class SchedulesEvent {}

class UpdateSchedulesConfigsEvent extends SchedulesEvent {
  final List<Schedule> schedules;
  UpdateSchedulesConfigsEvent({@required this.schedules});
}
