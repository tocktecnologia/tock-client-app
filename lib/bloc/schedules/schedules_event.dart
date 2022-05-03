part of 'schedules_bloc.dart';

@immutable
abstract class SchedulesEvent {}

class UpdateSchedulesConfigsEvent extends SchedulesEvent {
  final List<Schedule> schedules;
  UpdateSchedulesConfigsEvent({@required this.schedules});
}

class UpdateScheduleInListEvent extends SchedulesEvent {
  final Schedule schedule;
  UpdateScheduleInListEvent({@required this.schedule});
}

class DeleteScheduleEvent extends SchedulesEvent {
  final Schedule schedule;
  DeleteScheduleEvent({@required this.schedule});
}

class EnableScheduleEvent extends SchedulesEvent {
  final Schedule schedule;
  final newState;
  EnableScheduleEvent({@required this.schedule, this.newState});
}

class ExecuteScheduleActionsEvent extends SchedulesEvent {
  final List<ScheduleAction> scheduleAction;
  final bool reverse;
  ExecuteScheduleActionsEvent(
      {@required this.scheduleAction, this.reverse = false});
}
