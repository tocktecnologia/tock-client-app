class Endpoints {
  static const NetAddress = "http://10.0.1";
}

class MqttTopics {
  static const getStates = '\$aws/things/${Central.remoteId}/states';
  static const update = '\$aws/things/${Central.remoteId}/shadow/update';
  static const accepted =
      '\$aws/things/${Central.remoteId}/shadow/update/accepted';
}

class Central {
  static const remoteId = "E821C76A"; //"E821C457";
  static const localId = '10.0.1.10';
}

class DeviceTypes {
  static const LIGHT = "LIGHT";
  static const LIGHTS = "LIGHTS";
  static const PLUG = "PLUG";
  static const CONTROL = "CONTROL";
  static const DIMMER = "DIMMER";
  static const CAMERA = "CAMERA";
  static const SENSOR = "SENSOR";
}
