import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'schedules_event.dart';
part 'schedules_state.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  @override
  SchedulesState get initialState => SchedulesInitial();

  @override
  Stream<SchedulesState> mapEventToState(
    SchedulesEvent event,
  ) async* {
    try {} catch (e) {}
  }
}
