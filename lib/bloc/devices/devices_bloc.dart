import 'dart:async';
import 'dart:convert';
import 'package:client/screens/home/devices/device_state.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/services/mqtt/mqtt_service.dart';
import '../../shared/utils/handle_exceptions.dart';
import '../../shared/utils/locator.dart';
part 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit() : super(DevicesInitalState(<DeviceState>[]));

  List<DeviceState> deviceStateList = [];

  Future initListDevices(List<Device> deviceList) async {
    deviceStateList = deviceList
        .map<DeviceState>((device) => DeviceState(device: device))
        .toList();
    // await Future.delayed(const Duration(milliseconds: 10));

    emit(UpdatedDevicesState(deviceStateList));
  }

  Future<void> updateReportedDevices(String msg) async {
    if (deviceStateList.isEmpty) {
      // print("deviceStateList is empty ");
      return;
    }

    // deviceStateList[0].state = deviceStateList[0].state == "0" ? "1" : "0";

    final Map<String, dynamic> msgJson = jsonDecode(msg);
    if (!msgJson.containsKey("state")) {
      // print("not containsKey 'state' ");
      return;
    }

    if (!msgJson["state"].containsKey("reported")) {
      // print("not containsKey 'reported' ");
      return;
    }

    // emit(UpdatingDevicesState(deviceStateList));
    print("updateReportedDevices received: ${msgJson["state"]["reported"]}");
    msgJson["state"]["reported"].forEach((String k, v) {
      if (k.startsWith("pin")) {
        final pinReported = k.substring(3);
        final deviceIdx =
            deviceStateList.indexWhere((element) => element.pin == pinReported);
        // substiotution
        if (deviceIdx >= 0) {
          deviceStateList[deviceIdx] = DeviceState(
              device: deviceStateList[deviceIdx], state: v.toString());
        }
      }
    });

    emit(UpdatedDevicesState(deviceStateList));
  }

  Future<void> getDevicesStates(thingIdList) async {
    emit(GettingDevicesState());
    try {
      for (var thingId in thingIdList) {
        Locator.instance.get<MqttService>().getShadow(thingId);
      }
      // emit(UpdatedDevicesState(deviceStateList));
    } catch (e) {
      emit(UpdateDevicesErrorState(message: HandleExptions.message(e)));
    }
  }
}
