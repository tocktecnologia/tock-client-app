import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'light_event.dart';
part 'light_state.dart';

class LightBloc extends Bloc<LightEvent, LightState> {
  @override
  LightState get initialState => LightInitial();

  @override
  Stream<LightState> mapEventToState(
    LightEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
