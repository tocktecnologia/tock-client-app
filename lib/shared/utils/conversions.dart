import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';

class TockTime {
  /// UTC TO LOCAL /////////////////////////////////////////////////////////
  static Schedule scheduleUtc2local(Schedule schedule) {
    Schedule newSchedule = Schedule(
        scheduleTime: schedule.scheduleTime,
        scheduleAction: schedule.scheduleAction,
        scheduleId: schedule.scheduleId,
        scheduleName: schedule.scheduleName,
        scheduleState: schedule.scheduleState,
        scheduleType: schedule.scheduleType,
        scheduleWeek: schedule.scheduleWeek);

    newSchedule.scheduleWeek =
        utcDaysWeek2Local(newSchedule.scheduleWeek, newSchedule.scheduleTime);

    newSchedule.scheduleTime = utc2LocalTime(newSchedule.scheduleTime);
    return newSchedule;
  }

  static String utc2LocalTime(String scheduleTime) {
    // get hour and minuto from string
    final hour = int.parse(scheduleTime.split(':')[0]);
    final min = int.parse(scheduleTime.split(':')[1]);

    //get time (hour & minute) and says that its utc
    DateTime timeUtc = DateTime.utc(1992, 9, 8, hour, min);

    // get the time labeled utc and convert to local
    DateTime time = timeUtc.toLocal();

    return '${formatTime(time.hour.toString())}:${formatTime(time.minute.toString())}';
  }

  static List utcDaysWeek2Local(List scheduleWeek, String scheduleTime) {
    // get hour and minuto from string
    final hour = int.parse(scheduleTime.split(':')[0]);
    final min = int.parse(scheduleTime.split(':')[1]);

    //get time (hour & minute) and says that its utc
    DateTime timeUtc = DateTime.utc(1992, 9, 8, hour, min);
    // print('------ UTC -------');
    // print(
    //     'hour: ${timeUtc.hour},  min: ${timeUtc.minute}, week: ${timeUtc.weekday};');
    // get the time labeled utc and convert to local
    DateTime time = timeUtc.toLocal();
    // print('------ LOCAL -------');
    // print('hour: ${time.hour},  min: ${time.minute}, week: ${time.weekday};');

    if (timeUtc.weekday > time.weekday) {
      scheduleWeek = scheduleWeek
          .map<int>((day) => day.round() == 0 ? 6 : day.round() - 1)
          .toList();
    }
    // else if (timeUtc.weekday < time.weekday) {
    //   scheduleWeek.map<int>((day) => day.round() == 6 ? 0 : day.round() + 1);
    // }
    return scheduleWeek;
  }
  ///////////////////////////////////////////////////////////////////////////

  /// LOCAL TO UTC /////////////////////////////////////////////////////////
  static Schedule scheduleLocal2Utc(Schedule schedule) {
    Schedule newSchedule = Schedule(
        scheduleTime: schedule.scheduleTime,
        scheduleAction: schedule.scheduleAction,
        scheduleId: schedule.scheduleId,
        scheduleName: schedule.scheduleName,
        scheduleState: schedule.scheduleState,
        scheduleType: schedule.scheduleType,
        scheduleWeek: schedule.scheduleWeek);

    newSchedule.scheduleWeek =
        localDaysWeek2Utc(newSchedule.scheduleWeek, newSchedule.scheduleTime);

    newSchedule.scheduleTime = local2UtcTime(newSchedule.scheduleTime);
    return newSchedule;
  }

  static String local2UtcTime(String scheduleTime) {
    // get hour and minuto from string
    final hour = int.parse(scheduleTime.split(':')[0]);
    final min = int.parse(scheduleTime.split(':')[1]);

    // local time
    DateTime time = DateTime(1992, 9, 8, hour, min);

    //get time (hour & minute) and convert it to utc
    DateTime timeUtc = time.toUtc();

    return '${formatTime(timeUtc.hour.toString())}:${formatTime(timeUtc.minute.toString())}';
  }

  static List localDaysWeek2Utc(List scheduleWeek, String scheduleTime) {
    // get hour and minuto from string
    final hour = int.parse(scheduleTime.split(':')[0]);
    final min = int.parse(scheduleTime.split(':')[1]);

    // local
    DateTime time = DateTime(1992, 9, 8, hour, min);

    //get time (hour & minute) and convert it to utc
    DateTime timeUtc = DateTime(1992, 9, 8, hour, min).toUtc();

    if (timeUtc.weekday > time.weekday) {
      scheduleWeek = scheduleWeek
          .map<int>((day) => day.round() == 6 ? 0 : day.round() + 1)
          .toList();
    }
    // else if (timeUtc.weekday < time.weekday) {
    //   scheduleWeek.map<int>((day) => day.round() == 0 ? 6 : day.round() - 1);
    // }
    return scheduleWeek;
  }
  ////////////////////////////////////////////////////////////////////////////

  static formatTime(v) {
    v = int.parse(v);
    return v < 10 ? '0$v' : '$v';
  }
}
