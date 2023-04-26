import 'package:client/shared/model/data_user_model.dart';

class DeviceState extends Device {
  String? state;
  DeviceState({required Device device, state = "0"}) {
    label = device.label;
    localId = device.localId;
    objectId = device.objectId;
    pin = device.pin;
    remoteId = device.remoteId;
    type = device.type;
  }
}
