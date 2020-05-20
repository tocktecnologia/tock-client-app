import 'dart:async';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/exceptions.dart';
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

  setLights(lights) {
    _lights = lights;
  }

  @override
  Stream<LightsState> mapEventToState(
    LightsEvent event,
  ) async* {
    try {
      if (event is UpdateDevicesFromAwsEvent) {
        yield UpdatingDevicesState();

        _lights = event.devices
            .map<Light>((device) => Light(device: device, state: '0'))
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
      //
      else if (event is GetStatesLight) {
        yield LoadingLightStates();

        // reconnection aws mqtt
        final AwsIot awsIot = Locator.instance.get<AwsIot>();
        await awsIot.intialize();

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

        yield LoadedLightStates(lights: _lights);
      }
      //
      //
      // else if (event is TouchLightEvent) {
      //   yield UpdatingLightState(light: event.light);

      //   //change state for light came from event
      //   Light light = event.light;
      //   light.state = light.state == '1' ? '0' : '1';

      //   // verrify connection mqtt
      //   final AWSIotDevice awsIotDevice =
      //       Locator.instance.get<AwsIot>().awsIotDevice;
      //   final status = awsIotDevice.client.connectionStatus.state;
      //   if (status == MqttConnectionState.connected) {
      //     _updateMqtt(awsIotDevice, light);
      //     return;
      //   }

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
      // }
      //
      //
      else if (event is UpdateIdxLightsEvent) {
        yield LoadingLightStates();

        // update position
        final w = _lights.removeAt(event.oldIndex);
        _lights.insert(event.newIndex, w);

        yield ReorderedLightStates(lights: _lights);
      }
      //
      //
      else if (event is ChangeConfigsLightEvent) {
        yield LoadingLightStates();

        // update cnofigs
        _lights.elementAt(_lights.indexOf(event.light)).device =
            event.light.device;

        yield LoadedLightStates(lights: _lights);
      }
      //
      //
      // else if (event is ReceiveStateLightEvent) {
      //   yield UpdatingLightState(
      //       deviceId: event.deviceId, pin: event.pin, state: event.state);

      //   // for update list
      //   final index = _lights.indexWhere((light) =>
      //       light.device.remoteId == event.deviceId &&
      //       light.device.pin == event.pin);

      //   if (index < 0)
      //     yield LightStatesError(
      //       message:
      //           "pin${event.pin} do dispositivo ${event.deviceId} não encontrato no app. \nVerifiques o id das luzes adicionadas no aplicativo.",
      //     );

      //   final light = _lights.elementAt(index);

      //   _lights.elementAt(index).state = '${event.state}';

      //   // yield UpdatedLightConfigsState(lights: _lights);

      //   yield UpdatedLightState(lights: _lights);
      // }
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
