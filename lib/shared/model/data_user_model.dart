class DataUser {
  List<Device>? devices;
  String? email;
  EnvironmentLocation? environmentLocation;
  String? environmentName;
  List<void>? groups;
  String? identityId;
  List? objects;
  List? scenarios;
  List<Schedule>? schedules;
  List<WaterTank>? waterTanks;
  DataUser({
    devices,
    email,
    environmentLocation,
    environmentName,
    groups,
    identityId,
    objects,
    scenarios,
    schedules,
    waterTanks,
  });

  DataUser.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = <Device>[];
      json['devices'].forEach((v) {
        devices?.add(Device.fromJson(v));
      });
    }
    email = json['email'];
    environmentLocation = json['environment_location'] != null
        ? EnvironmentLocation.fromJson(json['environment_location'])
        : null;
    environmentName = json['environment_name'];
    // if (json['groups'] != null) {
    //   groups =  List<Null>();
    //   json['groups'].forEach((v) {
    //     groups.add( Null.fromJson(v));
    //   });
    // }
    identityId = json['identity_id'];
    if (json['objects'] != null) {
      objects = <Null>[];
      // json['objects'].forEach((v) {
      //   objects.add( Null.fromJson(v));
      // });
    }
    if (json['scenarios'] != null) {
      scenarios = <Null>[];
      // json['scenarios'].forEach((v) {
      //   scenarios.add( Null.fromJson(v));
      // });
    }
    if (json['schedules'] != null) {
      schedules = <Schedule>[];
      json['schedules'].forEach((v) {
        schedules?.add(Schedule.fromJson(v));
      });
    }
    if (json['water_tanks'] != null) {
      waterTanks = <WaterTank>[];
      json['water_tanks'].forEach((v) {
        waterTanks?.add(WaterTank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (devices != null) {
      data['devices'] = devices?.map((v) => v.toJson()).toList();
    }
    data['email'] = email;
    if (environmentLocation != null) {
      data['environment_location'] = environmentLocation?.toJson();
    }
    data['environment_name'] = environmentName;
    if (groups != null) {
      data['groups'] = {}; //groups.map((v) => v.toJson()).toList();
    }
    data['identity_id'] = identityId;
    if (objects != null) {
      data['objects'] = {}; //objects.map((v) => v.toJson()).toList();
    }
    if (scenarios != null) {
      data['scenarios'] = {}; // scenarios.map((v) => v.toJson()).toList();
    }
    if (schedules != null) {
      data['schedules'] = schedules?.map((v) => v.toJson()).toList();
    }
    if (waterTanks != null) {
      data['water_tanks'] = waterTanks?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaterTank {
  String? label;
  String? thingId;
  String? broker;
  WaterTank(label, thingId, broker);

  WaterTank.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    thingId = json['thing_id'];
    broker = json['broker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = label;
    data['thing_id'] = thingId;
    data['broker'] = broker;
    return data;
  }
}

class Scenario {}

class Group {}

class Object {}

class Device {
  String? label;
  String? localId;
  String? objectId;
  String? pin;
  String? remoteId;
  String? type;

  Device({label, localId, objectId, pin, remoteId, type});

  Device.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    localId = json['local_id'];
    objectId = json['object_id'];
    pin = json['pin'];
    remoteId = json['remote_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['local_id'] = localId;
    data['object_id'] = objectId;
    data['pin'] = pin;
    data['remote_id'] = remoteId;
    data['type'] = type;
    return data;
  }
}

class EnvironmentLocation {
  CommingAction? commingAction;
  Coordinates? coordinates;
  String? distance;
  String? functionStatus;
  CommingAction? leavingAction;

  EnvironmentLocation(
      {commingAction, coordinates, distance, functionStatus, leavingAction});

  EnvironmentLocation.fromJson(Map<String, dynamic> json) {
    commingAction = json['comming_action'] != null
        ? CommingAction.fromJson(json['comming_action'])
        : null;
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    distance = json['distance'];
    functionStatus = json['function_status'];
    leavingAction = json['leaving_action'] != null
        ? CommingAction.fromJson(json['leaving_action'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (commingAction != null) {
      data['comming_action'] = commingAction?.toJson();
    }
    if (coordinates != null) {
      data['coordinates'] = coordinates?.toJson();
    }
    data['distance'] = distance;
    data['function_status'] = functionStatus;
    if (leavingAction != null) {
      data['leaving_action'] = leavingAction?.toJson();
    }
    return data;
  }
}

class CommingAction {
  String? actionStatus;
  String? scenarioName;

  CommingAction({actionStatus, scenarioName});

  CommingAction.fromJson(Map<String, dynamic> json) {
    actionStatus = json['action_status'];
    scenarioName = json['scenario_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['action_status'] = actionStatus;
    data['scenario_name'] = scenarioName;
    return data;
  }
}

class Coordinates {
  String? latitude;
  String? longitude;

  Coordinates({latitude, longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Schedule {
  List<ScheduleAction>? scheduleAction;
  String? scheduleId;
  String? scheduleName;
  String? scheduleState;
  String? scheduleTime;
  String? scheduleType;
  List<dynamic>? scheduleWeek;

  Schedule(
      {scheduleAction,
      scheduleId,
      scheduleName,
      scheduleState,
      scheduleTime,
      scheduleType,
      scheduleWeek});

  Schedule.fromJson(Map<String, dynamic> json) {
    if (json['schedule_action'] != null) {
      scheduleAction = <ScheduleAction>[];
      json['schedule_action'].forEach((v) {
        scheduleAction?.add(ScheduleAction.fromJson(v));
      });
    }
    scheduleWeek = json['schedule_week'].cast<dynamic>();

    scheduleId = json['schedule_id'];
    scheduleName = json['schedule_name'];
    scheduleState = json['schedule_state'];
    scheduleTime = json['schedule_time'];
    scheduleType = json['schedule_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (scheduleAction != null) {
      data['schedule_action'] = scheduleAction?.map((v) => v.toJson()).toList();
    }
    data['schedule_id'] = scheduleId;
    data['schedule_name'] = scheduleName;
    data['schedule_state'] = scheduleState;
    data['schedule_time'] = scheduleTime;
    data['schedule_type'] = scheduleType;
    data['schedule_week'] = scheduleWeek;

    return data;
  }
}

class ScheduleAction {
  TockAction? action;
  String? type;

  ScheduleAction({action, type});

  ScheduleAction.fromJson(Map<String, dynamic> json) {
    action = (json['action'] != null
        ? TockAction.fromJson(json['action'])
        : 'ACTION') as TockAction?;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (action != null) {
      data['action'] = action?.toJson();
    }
    data['type'] = type;
    return data;
  }
}

class TockAction {
  String? actionId;
  String? delay;
  String? deviceId;
  String? event;
  String? label;
  String? objectId;
  String? section;
  String? type;

  TockAction(
      {actionId, delay, deviceId, event, label, objectId, section, type});

  TockAction.fromJson(Map<String, dynamic> json) {
    actionId = json['action_id'];
    delay = json['delay'];
    deviceId = json['device_id'];
    event = json['event'];
    label = json['label'];
    objectId = json['object_id'];
    section = json['section'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['action_id'] = actionId;
    data['delay'] = delay;
    data['device_id'] = deviceId;
    data['event'] = event;
    data['label'] = label;
    data['object_id'] = objectId;
    data['section'] = section;
    data['type'] = type;
    return data;
  }
}
