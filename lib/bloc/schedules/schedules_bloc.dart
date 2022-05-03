import 'dart:async';

import 'package:aws_iot/aws_iot.dart';
import 'package:aws_iot/aws_iot.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/api/schedules_aws.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/conversions.dart';
import 'package:flutter_login_setup_cognito/shared/utils/exceptions_tock.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'schedules_event.dart';
part 'schedules_state.dart';

class SchedulesBloc extends HydratedBloc<SchedulesEvent, SchedulesState> {
  @override
  SchedulesState get initialState => super.initialState ?? SchedulesInitial();

  List<Schedule> _schedules = List<Schedule>();
  get schedules => _schedules;

  @override
  Stream<SchedulesState> mapEventToState(
    SchedulesEvent event,
  ) async* {
    try {
      // update list schedules from remote
      if (event is UpdateSchedulesConfigsEvent) {
        yield UpdatingSchedulesState();

        // conver schedules Utc to local
        _schedules = event.schedules
            .map((schedule) => TockTime.scheduleUtc2local(schedule))
            .toList();

        yield UpdatedSchedulesState(schedules: _schedules);
      }

      //
      else if (event is UpdateScheduleInListEvent) {
        yield UpdatingSchedulesState();

        //find index of schedule
        final index = _schedules.indexWhere(
            (schedule) => schedule.scheduleId == event.schedule.scheduleId);

        if (index < 0) {
          // request aws
          await Locator.instance
              .get<AwsApiSchedules>()
              .createSchedule(event.schedule);

          _schedules.add(event.schedule);
        } else {
          // need change to int schedule Week
          event.schedule.scheduleWeek =
              event.schedule.scheduleWeek.map<int>((v) => v.round()).toList();

          await Locator.instance
              .get<AwsApiSchedules>()
              .updateSchedule(schedule: event.schedule);

          _schedules.insert(index, event.schedule);
          _schedules.removeAt(index + 1);
        }

        yield UpdatedSchedulesState(schedules: _schedules);
      }
      //
      else if (event is DeleteScheduleEvent) {
        yield DeletingScheduleState(schedule: event.schedule);

        await Locator.instance
            .get<AwsApiSchedules>()
            .deleteSchedule(event.schedule);

        print('_schedules length : ${_schedules.length}');

        if (_schedules.length == 1) {
          await Future.delayed(Duration(seconds: 1));
          _schedules = List<Schedule>();
          yield UpdatedSchedulesState(schedules: _schedules);
          return;
        }

        final index = _schedules.indexOf(event.schedule);
        _schedules.removeAt(index);

        yield UpdatedSchedulesState(schedules: _schedules);
      }
      //
      else if (event is EnableScheduleEvent) {
        yield EnablingScheduleState(schedule: event.schedule);

        // need change to int schedule Week (this need before request)
        event.schedule.scheduleWeek =
            event.schedule.scheduleWeek.map<int>((v) => v.round()).toList();

        await Locator.instance
            .get<AwsApiSchedules>()
            .updateSchedule(schedule: event.schedule, newState: event.newState);

        event.schedule.scheduleState = event.newState;

        final index = _schedules.indexWhere(
            (schedule) => schedule.scheduleId == event.schedule.scheduleId);

        _schedules.elementAt(index).scheduleState =
            event.schedule.scheduleState;

        yield UpdatedSchedulesState(schedules: _schedules);
      } else if (event is ExecuteScheduleActionsEvent) {
        yield ExecutingScheduleActionsState();
        event.scheduleAction.forEach((element) {
          final deviceId = element.action.deviceId;
          final pinNumber = element.action.section;
          int stateToExecute = int.parse(element.action.event);
          stateToExecute =
              event.reverse ? (stateToExecute == 0 ? 1 : 0) : stateToExecute;

          AWSIotDevice awsIotDevice =
              Locator.instance.get<AwsIot>().awsIotDevice;
          awsIotDevice.publishJson(
            {
              'state': {
                'desired': {'pin$pinNumber': stateToExecute}
              }
            },
            topic: '\$aws/things/$deviceId/shadow/update',
          );
        });
        yield UpdatedSchedulesState(schedules: _schedules);
      }
    } on TimeoutException catch (_) {
      yield UpdateSchedulesErrorState(
          message: 'Tempo máximo de requisição alcançado.');
    } on ApiGatewayException catch (e) {
      yield UpdateSchedulesErrorState(message: e.message);
    } catch (e) {
      yield UpdateSchedulesErrorState(message: e.message);
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
        final listScheduleJson = _schedules
            .map<Map>((scheduleObject) => scheduleObject.toJson())
            .toList();
        return {'schedules': listScheduleJson};
      }

      final listScheduleJson = _schedules
          .map<Map>((scheduleObject) => scheduleObject.toJson())
          .toList();
      return {'schedules': listScheduleJson};
    } catch (_) {
      return null;
    }
  }
}
