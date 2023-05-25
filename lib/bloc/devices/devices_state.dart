part of 'devices_bloc.dart';

abstract class DevicesState {}

class DevicesInitalState extends DevicesState {
  final List<DeviceState> deviceStateList;
  DevicesInitalState(this.deviceStateList);
}

class UpdatedDevicesState extends DevicesState {
  final List<DeviceState> deviceStateList;
  UpdatedDevicesState(this.deviceStateList);
}

class GettingDevicesState extends DevicesState {
  GettingDevicesState();
}

class UpdateDevicesErrorState extends DevicesState {
  final String message;
  UpdateDevicesErrorState({required this.message});
}
