import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
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
      if (event is GetStatesLight) {
        yield LoadingLightStates();
        final response = await Locator.instance.get<FirmwareApi>().getStates();
        print(response);
        // for (int i = 0; i < 160; i++) {
        //   print(i);
        // }
        yield LoadedLightStates();
      }
    } catch (e) {
      LoadLightStatesError(message: e.toString());
    }
  }
}
