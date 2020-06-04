import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:meta/meta.dart';

part 'central_event.dart';
part 'central_state.dart';

class CentralBloc extends Bloc<CentralEvent, CentralState> {
  @override
  CentralState get initialState => CentralInitial();

  @override
  Stream<CentralState> mapEventToState(
    CentralEvent event,
  ) async* {
    try {
      if (event is GetUpdateLightsFromCentralEvent) {
        yield UpdatingLightsFromCentralState();

        final statesJson =
            await Locator.instance.get<FirmwareApi>().getStates();

        String mStates = statesJson['states']['estados'];

        mStates.replaceFirst('xxxxxx', '0');

        if (event.lights.length < mStates.length) {
          event.lights.forEach((light) {
            final index = int.parse(light.device.pin) - 1;
            light.state = mStates[index];
          });
        } else {
          yield UpdateLightsFromCentralErrorState(
              message:
                  "Quantidade de estados da central maior q a quantidade no aplicativo");
        }

        yield UpdatedLightsFromCentralState(lights: event.lights);
      }
    } catch (e) {
      final msg =
          "Não foi possível recuperar estados da central, verifique sua conexão na rede automação local.";
      yield UpdateLightsFromCentralErrorState(message: msg);
    }
  }
}
