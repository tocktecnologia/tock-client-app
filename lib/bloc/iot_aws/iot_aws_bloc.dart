import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/handle_exceptions.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:meta/meta.dart';

part 'iot_aws_event.dart';
part 'iot_aws_state.dart';

class IotAwsBloc extends Bloc<IotAwsEvent, IotAwsState> {
  @override
  IotAwsState get initialState => IotAwsInitial();

  @override
  Stream<IotAwsState> mapEventToState(
    IotAwsEvent event,
  ) async* {
    try {
      if (event is ConnectIotAwsEvent) {
        yield ConnectingIotAwsState();
        await Locator.instance.get<AwsIot>().intialize();
        yield ConnectedIotAwsState();
      }
      //
      else if (event is UpdateLightsFromShadowEvent) {
        yield UpdatingLightsFromShadowState();

        final Map mStates = event.statesJson['reported'];
        // print(mStates);
        event.lights.forEach((light) {
          if (mStates.containsKey('pin${light.device.pin}')) {
            final stateLight = mStates['pin${light.device.pin}'];
            light.state = '$stateLight';
          }
        });

        yield UpdatedLightsFromShadowState(lights: event.lights);
      } else if (event is UpdateLightsFromNodeCentralEvent) {
        yield UpdatingLightsFromNodeCentralState();

        Map mStates = event.statesJson['reported'];
        // print('mStates:\n$mStates');
        event.lights.forEach((light) {
          if (mStates.containsKey('pin${light.device.pin}')) {
            light.state = mStates['pin${light.device.pin}'];
          }
        });

        yield UpdatedLightsFromNodeCentralState(lights: event.lights);
      }

      //
      else if (event is GetUpdateLightsFromShadowEvent) {
        yield UpdatingLightsFromShadowState();
        await Future.delayed(Duration(milliseconds: 200));
        Locator.instance
            .get<AwsIot>()
            .awsIotDevice
            .publishJson({}, topic: MqttTopics.shadowGet);
      } else if (event is GetUpdateLightsFromNodeCentralEvent) {
        yield UpdatingLightsFromShadowState();
        await Future.delayed(Duration(milliseconds: 200));
        Locator.instance
            .get<AwsIot>()
            .awsIotDevice
            .publishJson({}, topic: MqttTopics.getStates);
      }
      //
      // else if (event is ReceiveUpdateIotAwsEvent) {
      //   // yield UpdatingLighState(
      //   //     deviceId: event.deviceId, pin: event.pin, state: event.state);
      //   print('changing state to getted');
      //   yield GettedLighState(
      //       deviceId: event.deviceId, pin: event.pin, state: event.state);
      // }
      // //
      // else if (event is GetUpdateIotAwsEvent) {
      //   yield GettingLighState(
      //       deviceId: event.deviceId, pin: event.pin, state: event.state);
      // }
      //
    } catch (e) {
      yield ConnectionErrorIotAwsState(mesage: HandleExptions.message(e));
    }
  }
}
