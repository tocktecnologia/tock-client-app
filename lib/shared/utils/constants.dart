class Endpoints {
  static const NetAddress = "http://10.0.1";

  static const String STAGE = "prod";
  static const String AWSBASE =
      "https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com";
}

class MqttTopics {
  static const shadowGet = '\$aws/things/${Central.remoteId}/shadow/get';
  static const shadowUpdate = '\$aws/things/${Central.remoteId}/shadow/update';
  static const shadowGetAccepted =
      '\$aws/things/${Central.remoteId}/shadow/get/accepted';
  static const shadowUpdateAccepted =
      '\$aws/things/${Central.remoteId}/shadow/update/accepted';

  static const getStates = '\$aws/things/${Central.remoteId}/states';
}

class Central {
  static const remoteId = "E82723EB"; //"E821C76A";
  static const localId = '10.0.1.10';
}

class DeviceTypes {
  static const LIGHT = "LIGHT";
  static const BOMB = "BOMB";
  static const LIGHTS = "LIGHTS";
  static const PLUG = "PLUG";
  static const CONTROL = "CONTROL";
  static const DIMMER = "DIMMER";
  static const CAMERA = "CAMERA";
  static const SENSOR = "SENSOR";
}

class LightStatesLogic {
  static const String LIGHT_ON = "1";
  static const String LIGHT_OFF = "0";
}
