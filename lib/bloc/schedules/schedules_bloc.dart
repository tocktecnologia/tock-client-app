import 'dart:async';

import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'schedules_event.dart';
part 'schedules_state.dart';

class SchedulesBloc extends HydratedBloc<SchedulesEvent, SchedulesState> {
  @override
  SchedulesState get initialState => super.initialState ?? SchedulesInitial();

  List<Schedule> _schedules = List<Schedule>();

  @override
  Stream<SchedulesState> mapEventToState(
    SchedulesEvent event,
  ) async* {
    try {
      // update list schedules from remote
      if (event is UpdateSchedulesConfigsEvent) {
        yield UpdatingSchedulesState();
        _schedules = event.schedules;
        yield UpdatedSchedulesState(schedules: _schedules);
      }
    } catch (e) {
      yield UpdatSchedulesErrorState(message: e.toString());
    }
  }

  @override
  SchedulesState fromJson(Map<String, dynamic> json) {
    try {
      _schedules = json['schedules']
          .map<Schedule>((scheduleJson) => Schedule.fromJson(scheduleJson))
          .toList();
      return UpdatedSchedulesState(schedules: _schedules);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(SchedulesState state) {
    try {
      if (state is UpdatedSchedulesState) {
        final listScheduleJson = state.schedules
            .map<Map>((scheduleObject) => scheduleObject.toJson())
            .toList();
        return {'schedules': listScheduleJson};
      } else
        return null;
    } catch (_) {
      return null;
    }
  }
}
