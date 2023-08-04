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
    if (deviceStateList.isNotEmpty) return;

    deviceStateList = deviceList
        .map<DeviceState>((device) => DeviceState(device: device))
        .toList();
    // await Future.delayed(const Duration(milliseconds: 10));

    emit(UpdatedDevicesState(deviceStateList));
  }

  Future<void> updateReportedDevices(String msg, String topic) async {
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

    // get remote id that requested change of pin value
    final topicSplitted = topic.split("/");
    String remoteIdTarget = topicSplitted.length > 3
        ? topicSplitted.elementAt(2)
        : topicSplitted.first;

    // print("updateReportedDevices received: ${msgJson["state"]["reported"]}");
    msgJson["state"]["reported"].forEach((String k, v) {
      if (k.startsWith("pin")) {
        final pinReported = k.substring(3);
        final deviceIdx = deviceStateList.indexWhere((element) {
          return (element.pin == pinReported &&
              element.remoteId == remoteIdTarget);
        });

        // substitution
        if (deviceIdx >= 0) {
          deviceStateList[deviceIdx] = DeviceState(
              device: deviceStateList[deviceIdx], state: v.toString());

          // print("\ndeviceIdx: $deviceIdx");
          // print(
          //     "deviceStateList[deviceIdx].state: ${deviceStateList[deviceIdx].state}");
          // print(
          //     "deviceStateList[deviceIdx].remoteId: ${deviceStateList[deviceIdx].remoteId}");
          // print(
          //     "deviceStateList[deviceIdx].label: ${deviceStateList[deviceIdx].label}");

          // print("deviceStateList[10].state: ${deviceStateList[10].state}");
          // print(
          //     "deviceStateList[10].remoteId: ${deviceStateList[10].remoteId}");
          // print("deviceStateList[10].label: ${deviceStateList[10].label}");
        }
      }
    });

    // await Future.delayed(const Duration(milliseconds: 300));

    emit(UpdatedDevicesState(deviceStateList));
  }

  Future<void> getDevicesStates() async {
    emit(GettingDevicesState());
    if (deviceStateList.isEmpty) return;

    try {
      final seen = <String>{};
      List<Device> devicesUnique = deviceStateList
          .where((device) => seen.add(device.remoteId!))
          .toList();

      for (int i = 0; i < devicesUnique.length; i++) {
        Locator.instance
            .get<MqttService>()
            .getShadow(devicesUnique[i].remoteId);
      }

      // for (var thingId in thingIdList) {
      //   Locator.instance.get<MqttService>().getShadow(thingId);
      // }
      // emit(UpdatedDevicesState(deviceStateList));
    } catch (e) {
      emit(UpdateDevicesErrorState(message: HandleExptions.message(e)));
    }
  }
}
