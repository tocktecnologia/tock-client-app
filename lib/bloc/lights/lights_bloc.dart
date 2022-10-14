import 'dart:async';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/handle_exceptions.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'lights_event.dart';
part 'lights_state.dart';

class LightsBloc extends HydratedBloc<LightsEvent, LightsState> {
  @override
  LightsState get initialState => super.initialState ?? LightsInitial();

  List<Light> _lights = [];
  get lights => _lights;

  setLights(lights) {
    _lights = lights;
  }

  @override
  Stream<LightsState> mapEventToState(
    LightsEvent event,
  ) async* {
    try {
      if (event is UpdateDevicesFromAwsAPIEvent) {
        yield UpdatingDevicesFromAwsState();

        _lights.clear();
        _lights = event.devices
            .map<Light>((device) => Light(device: device, state: '1'))
            .toList();

        // ###################### LOCAL (pega os estados da central) ###############
        // final Map response =
        //     await Locator.instance.get<FirmwareApi>().getStates();
        // if (response['status'] == 'falha')
        //   yield LoadLightStatesError(message: response['message']);

        // // update from remote list
        // final states = response['message']['states'];
        // _lights = event.devices
        //     .map<Light>((device) =>
        //         Light(device: device, state: states['pin${device.pin}'] ?? '3'))
        //     .toList();

        yield UpdatedDevicesState(lights: _lights);
      }

      //
      else if (event is UpdateLightsFromCentralEvent) {
        yield UpdatingDevicesState();

        String mStates = event.statesJson['states'];
        print(mStates);
        if (_lights.length < mStates.length) {
          _lights.forEach((light) {
            light.state = mStates[int.parse(light.device.pin) - 1];
          });
        }

        //await Future.delayed(Duration(seconds: 1));

        //############################ LOCAL ############################
        // final Map response =
        //     await Locator.instance.get<FirmwareApi>().getStates();
        // if (response['status'] == 'falha')
        //   yield LoadLightStatesError(message: response['message']);

        // update states in local list
        // final states = response['message']['states'];
        // _lights = _lights
        //     .map((light) => Light(
        //         device: light.device,
        //         state: states['pin${light.device.pin}'] ?? '3'))
        //     .toList();

        // /yield UpdatedDevicesState(lights: _lights);
        yield UpdatedLightsFromCentralState(lights: _lights);
      }
      // else if (event is UpdateLightsFromShadowEvent) {
      //   yield UpdatingDevicesState();

      //   final Map mStates = event.statesJson['reported'];
      //   print(mStates);
      //   _lights.forEach((light) {
      //     if (mStates.containsKey('pin${light.device.pin}'))
      //       light.state = mStates['pin${int.parse(light.device.pin)}'];
      //   });

      //   yield UpdatedLightsFromCentralState(lights: _lights);
      // }
      //
      else if (event is ReconnectAwsIotEvent) {
        yield UpdatingDevicesState();

        // reconnection aws mqtt
        final AwsIot awsIot = Locator.instance.get<AwsIot>();
        await awsIot.intialize();

        yield UpdatedDevicesState(lights: _lights);

        //############################ LOCAL ############################
        // // if disconnected restart connection mqtt
        // Locator.instance.get<AwsIot>().intialize();

        // // request to module change state
        // final Map response = await Locator.instance
        //     .get<FirmwareApi>()
        //     .updateState(light: event.light);

        // // if fails , state error
        // if (response['status'] == 'falha') {
        //   yield LoadLightStatesError(message: response['message']);
        //   return;
        // }

        // // update state in list bloc
        // final index = _lights
        //     .indexWhere((light) => light.device.pin == event.light.device.pin);
        // _lights.elementAt(index).state = event.light.state;

        // yield UpdatedLightState(light: _lights.elementAt(index));
      }
    } catch (e) {
      LightStatesError(message: HandleExptions.message(e));
    }
  }

  @override
  LightsState fromJson(Map<String, dynamic> json) {
    try {
      _lights = json['lights']
          .map<Light>((lighJson) => Light.fromJson(lighJson))
          .toList();
      return UpdatedDevicesState(lights: _lights);
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
