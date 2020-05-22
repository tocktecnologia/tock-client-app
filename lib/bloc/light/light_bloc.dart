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
    try {
      if (event is ReceiveUpdateLightEvent) {
        // yield UpdatingLighState(
        //     deviceId: event.deviceId, pin: event.pin, state: event.state);
        print('changing state to getted');
        yield GettedLighState(
            deviceId: event.deviceId, pin: event.pin, state: event.state);
      }
      //
      else if (event is GetUpdateLightEvent) {
        yield GettingLighState(
            deviceId: event.deviceId, pin: event.pin, state: event.state);
      }
    } catch (e) {}
  }
}
