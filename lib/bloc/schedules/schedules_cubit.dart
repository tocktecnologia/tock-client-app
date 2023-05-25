import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/shared/model/data_user_model.dart';

part 'schedules_state.dart';

class SchedulesCubit extends Cubit<SchedulesState> {
  SchedulesCubit() : super(SchedulesInitial());

  List<Schedule> scheduleList = [];

  Future<void> initListSchedules(List<Schedule> scheduleList) async {
    this.scheduleList = scheduleList;
    emit(UpdatedSchedulesState(schedules: scheduleList));
  }
}
