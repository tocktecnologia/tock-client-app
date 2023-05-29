import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/utils/constants.dart';

class DeviceState extends Device {
  String? state;
  DeviceState({required Device device, state}) {
    label = device.label;
    localId = device.localId;
    objectId = device.objectId;
    pin = device.pin;
    remoteId = device.remoteId;
    type = device.type;
    stateOn = device.stateOn;
    this.state = state ?? LightStatesLogic.LIGHT_OFF;
  }
}
