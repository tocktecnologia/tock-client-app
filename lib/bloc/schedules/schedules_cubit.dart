import 'dart:async';

import 'package:client/shared/services/api/schedules_aws.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/utils/conversions.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/shared/model/data_user_model.dart';

part 'schedules_state.dart';

class SchedulesCubit extends Cubit<SchedulesState> {
  SchedulesCubit() : super(SchedulesInitial());

  List<Schedule> _schedules = [];
  get schedules => _schedules;

  Future<void> initListSchedules(List<Schedule> scheduleList) async {
    _schedules = scheduleList;
    emit(UpdatedSchedulesState(schedules: scheduleList));
  }

  Future<void> executeScheduleActions(List<ScheduleAction> scheduleAction,
      {bool reverse = false}) async {
    try {
      for (var element in scheduleAction) {
        final deviceId = element.action?.deviceId;
        final pinNumber = element.action?.section;
        int stateToExecute = int.parse((element.action?.event)!);

        stateToExecute =
            reverse ? (stateToExecute == 0 ? 1 : 0) : stateToExecute;

        Locator.instance.get<MqttService>().publishJson(
          {
            'state': {
              'desired': {'pin$pinNumber': stateToExecute}
            }
          },
          '\$aws/things/$deviceId/shadow/update',
        );
      }
    } catch (e) {
      emit(UpdateSchedulesErrorState(message: e.toString()));
    }
  }

  Future<void> updateSchedulesConfigs(List<Schedule> schedules) async {
    try {
      emit(UpdatingSchedulesState());

      // conver schedules Utc to local
      _schedules = schedules
          .map((schedule) => TockTime.scheduleUtc2local(schedule))
          .toList();

      emit(UpdatedSchedulesState(schedules: _schedules));
    } catch (e) {
      emit(UpdateSchedulesErrorState(message: e.toString()));
    }
  }

  Future<void> updateScheduleInList(final Schedule schedule) async {
    try {
      emit(UpdatingSchedulesState());

      //find index of schedule
      final index = _schedules
          .indexWhere((schedule) => schedule.scheduleId == schedule.scheduleId);

      if (index < 0) {
        // request aws
        await Locator.instance.get<AwsApiSchedules>().createSchedule(schedule);
        // await Future.delayed(const Duration(seconds: 1));

        _schedules.add(schedule);
      } else {
        // need change to int schedule Week
        schedule.scheduleWeek =
            schedule.scheduleWeek?.map<int>((v) => v.round()).toList();

        // await Locator.instance
        //     .get<AwsApiSchedules>()
        //     .updateSchedule(schedule: event.schedule);
        await Future.delayed(const Duration(seconds: 1));

        _schedules.insert(index, schedule);
        _schedules.removeAt(index + 1);
      }

      emit(UpdatedSchedulesState(schedules: _schedules));
    } on TimeoutException catch (_) {
      emit(UpdateSchedulesErrorState(
          message: 'Tempo máximo de requisição alcançado.'));
    } catch (e) {
      emit(UpdateSchedulesErrorState(message: e.toString()));
    }
  }

  Future<void> deleteSchedule(final Schedule schedule) async {
    try {
      emit(DeletingScheduleState(schedule: schedule));

      // await Locator.instance.get<AwsApiSchedules>().deleteSchedule(schedule);
      await Future.delayed(const Duration(seconds: 1));

      print('_schedules length : ${_schedules.length}');

      if (_schedules.length == 1) {
        await Future.delayed(const Duration(seconds: 1));
        _schedules = [];

        emit(UpdatedSchedulesState(schedules: _schedules));
        return;
      }

      final index = _schedules.indexOf(schedule);
      _schedules.removeAt(index);

      emit(UpdatedSchedulesState(schedules: _schedules));
    } on TimeoutException catch (_) {
      emit(UpdateSchedulesErrorState(
          message: 'Tempo máximo de requisição alcançado.'));
    } catch (e) {
      emit(UpdateSchedulesErrorState(message: e.toString()));
    }
  }

  Future<void> enableSchedule(Schedule schedule, newState) async {
    try {
      emit(EnablingScheduleState(schedule: schedule));

      // need change to int schedule Week (this need before request)
      schedule.scheduleWeek =
          schedule.scheduleWeek?.map<int>((v) => v.round()).toList();

      // await Locator.instance
      //     .get<AwsApiSchedules>()
      //     .updateSchedule(schedule: schedule, newState: newState);
      await Future.delayed(const Duration(seconds: 1));

      schedule.scheduleState = newState;

      final index = _schedules
          .indexWhere((schedule) => schedule.scheduleId == schedule.scheduleId);

      _schedules.elementAt(index).scheduleState = schedule.scheduleState;

      emit(UpdatedSchedulesState(schedules: _schedules));
    } on TimeoutException catch (_) {
      emit(UpdateSchedulesErrorState(
          message: 'Tempo máximo de requisição alcançado.'));
    } catch (e) {
      emit(UpdateSchedulesErrorState(message: e.toString()));
    }
  }
}
