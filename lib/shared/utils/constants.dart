class Endpoints {
  static const NetAddress = "http://10.0.1";

  static String STAGE = "prod";
  static String AWSBASE =
      "https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com";
}

class MqttTopics {
  static const getStates = '\$aws/things/${Central.remoteId}/states';
  static const update = '\$aws/things/${Central.remoteId}/shadow/update';
  static const accepted =
      '\$aws/things/${Central.remoteId}/shadow/update/accepted';
}

class Central {
  static const remoteId = "E82723EB"; //"E821C76A";
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

class LightStatesLogic {
  static const String LIGHT_ON = "0";
  static const String LIGHT_OFF = "1";
}
