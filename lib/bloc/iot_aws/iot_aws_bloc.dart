import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
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
