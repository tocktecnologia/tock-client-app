class Endpoints {
  static const NetAddress = "http://10.0.1";

  static const String STAGE = "prod";
  static const String AWSBASE =
      "https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com";
}

class MqttTopics {
  static const tockUpdate = 'tock/things/${ThingAWS.piscinaRemoteId}/update';
  static const tockUpdateReturn = '$tockUpdate/return';

  static String topicShadowGet(thingId) {
    return '\$aws/things/${thingId}/shadow/get';
  }

  static String topicShadowUpdate(thingId) {
    return '\$aws/things/${thingId}/shadow/update';
  }

  static String topicShadowGetAccepted(thingId) {
    return '\$aws/things/${thingId}/shadow/get/accepted';
  }

  static String topicShadowUpdateAccepted(thingId) {
    return '\$aws/things/${thingId}/shadow/update/accepted';
  }

  // static const shadowGet =
  //     '\$aws/things/${ThingAWS.centralRemoteId}/shadow/get';
  // static const shadowUpdate =
  //     '\$aws/things/${ThingAWS.centralRemoteId}/shadow/update';
  // static const shadowGetAccepted =
  //     '\$aws/things/${ThingAWS.centralRemoteId}/shadow/get/accepted';
  // static const shadowUpdateAccepted =
  //     '\$aws/things/${ThingAWS.centralRemoteId}/shadow/update/accepted';

  static const getStates = '\$aws/things/${ThingAWS.centralRemoteId}/states';
  static const getStatesFromCentral =
      '\$aws/things/${ThingAWS.centralRemoteId}/states/ret';
}

class ThingAWS {
  static List<String> getThingIds() {
    // return ["3A9F416A"];

    return ["e3704f79", "fadc60ef", "3A9F416A"];
  }

  static const centralRemoteId = "3A9F416A"; //"fadc60ef"; //"E821C76A";
  static const piscinaRemoteId = "pool-green2b"; //"E821C76A";
  static const localId = '10.0.1.10';
}

class DeviceTypes {
  static const LIGHT = "LIGHT";
  static const BOMB = "BOMB";
  static const PULSE_ONOFF = "PULSE-ONOFF";
  static const PULSE_COLOR = "PULSE-COLOR";

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
