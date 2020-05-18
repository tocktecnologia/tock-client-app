import 'dart:async';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'lights_event.dart';
part 'lights_state.dart';

class LightsBloc extends HydratedBloc<LightsEvent, LightsState> {
  @override
  LightsState get initialState => super.initialState ?? LightsInitial();

  List<Light> _lights = List<Light>();
  get lights => _lights;

  @override
  Stream<LightsState> mapEventToState(
    LightsEvent event,
  ) async* {
    try {
      if (event is UpdateLightConfigsEvent) {
        yield LoadingLightStates();
        final Map response =
            await Locator.instance.get<FirmwareApi>().getStates();
        if (response['status'] == 'falha')
          yield LoadLightStatesError(message: response['message']);

        // update from remote list
        final states = response['message']['states'];
        _lights = event.userDevices
            .map<Light>((device) =>
                Light(device: device, state: states['pin${device.pin}'] ?? '3'))
            .toList();

        yield LoadedLightStates(lights: lights);
        //
      } else if (event is GetStatesLight) {
        yield LoadingLightStates();
        final Map response =
            await Locator.instance.get<FirmwareApi>().getStates();
        if (response['status'] == 'falha')
          yield LoadLightStatesError(message: response['message']);

        // update states in local list
        final states = response['message']['states'];
        _lights = _lights
            .map((light) => Light(
                device: light.device,
                state: states['pin${light.device.pin}'] ?? '3'))
            .toList();

        yield LoadedLightStates(lights: _lights);
        //
      } else if (event is TouchLightEvent) {
        yield UpdatingLightState(light: event.light);

        final Map response =
            await Locator.instance.get<FirmwareApi>().updateState();
        print(response);

        final index = _lights
            .indexWhere((light) => light.device.pin == event.light.device.pin);
        _lights.elementAt(index).state = event.light.state == '1' ? '0' : '1';

        yield UpdatedLightState(light: _lights.elementAt(index));
        //
      } else if (event is UpdateIdxLightsEvent) {
        yield LoadingLightStates();

        // update position
        final w = _lights.removeAt(event.oldIndex);
        _lights.insert(event.newIndex, w);

        yield LoadedLightStates(lights: _lights);
      }
    } catch (e) {
      LoadLightStatesError(message: e.toString());
    }
  }

  @override
  LightsState fromJson(Map<String, dynamic> json) {
    try {
      _lights = json['lights']
          .map<Light>((lighJson) => Light.fromJson(lighJson))
          .toList();
      return LoadedLightStates(lights: lights);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(LightsState state) {
    try {
      final lightsJson = _lights.map<Map>((light) => light.toJson()).toList();
      return {"lights": lightsJson};
    } catch (_) {
      return null;
    }
  }
}
