import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:meta/meta.dart';

part 'lights_event.dart';
part 'lights_state.dart';

class LightsBloc extends Bloc<LightsEvent, LightsState> {
  @override
  LightsState get initialState => LightsInitial();

  @override
  Stream<LightsState> mapEventToState(
    LightsEvent event,
  ) async* {
    try {
      if (event is GetStateLight) {
        yield LoadingLightState(lightId: event.lightId);
        await  Locator.instance.get<FirmwareApi>()
        yield LoadingLightState(lightId: event.lightId);
      }
    } catch (e) {}
  }
}
