import 'dart:async';
import 'dart:convert';
import 'package:client/screens/home/devices/device_state.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    print("msg: $msg");
    if (deviceStateList.isEmpty) {
      print("deviceStateList is empty ");
      return;
    }

    // deviceStateList[0].state = deviceStateList[0].state == "0" ? "1" : "0";

    final Map<String, dynamic> msgJson = jsonDecode(msg);
    if (!msgJson.containsKey("state")) {
      print("not containsKey 'state' ");
      return;
    }

    if (!msgJson["state"].containsKey("reported")) {
      print("not containsKey 'reported' ");
      return;
    }

    // emit(UpdatingDevicesState(deviceStateList));
    print(msgJson["state"]["reported"]);
    msgJson["state"]["reported"].forEach((String k, v) {
      final pinReported = k.substring(3);
      final deviceIdx =
          deviceStateList.indexWhere((element) => element.pin == pinReported);
      // substiotution
      if (deviceIdx >= 0) {
        deviceStateList[deviceIdx] = DeviceState(
            device: deviceStateList[deviceIdx], state: v.toString());
      }
    });

    emit(UpdatedDevicesState(deviceStateList));
  }
}
