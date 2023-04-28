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
    if (deviceStateList.isEmpty) return;
    deviceStateList[0].state = deviceStateList[0].state == "0" ? "1" : "0";

    final Map<String, dynamic> msgJson = jsonDecode(msg);
    if (!msgJson.containsKey("state")) return;
    if (!msgJson["state"].containsKey("reported")) return;

    emit(UpdatingDevicesState(deviceStateList));

    // msgJson["state"]["reported"].foreach((k, v) {
    //   final pinReported = k[3];
    //   final deviceIdx =
    //       deviceStateList.indexWhere((element) => element.pin = pinReported);
    //   // substiotution
    //   if (deviceIdx >= 0) {
    //     deviceStateList[deviceIdx] =
    //         DeviceState(device: deviceStateList[deviceIdx], state: v);
    //   }
    // });

    await Future.delayed(const Duration(seconds: 1));
    emit(UpdatedDevicesState(deviceStateList));
  }
}
