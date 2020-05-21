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
      //
      if (event is ReceiveUpdateLightEvent) {
        yield UpdatingLighState(
            deviceId: event.deviceId, pin: event.pin, state: event.state);
        print('pin: ${event.pin}');
        print('pinState: ${event.state}');

        //await Future.delayed(Duration(milliseconds: 500));
        // yield UpdatingLighState();
        // _lights.singleWhere((light) => light.device.remoteId == event.devices);
        yield UpdatedLighState(
            deviceId: event.deviceId, pin: event.pin, state: event.state);
      }
    } catch (_) {}
  }
}
