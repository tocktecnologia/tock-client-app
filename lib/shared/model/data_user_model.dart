class DataUser {
  List<Device> devices;
  String email;
  EnvironmentLocation environmentLocation;
  String environmentName;
  List<Null> groups;
  String identityId;
  List<Null> objects;
  List<Null> scenarios;
  List<Schedule> schedules;
  List<WaterTank> waterTanks;
  DataUser({
    this.devices,
    this.email,
    this.environmentLocation,
    this.environmentName,
    this.groups,
    this.identityId,
    this.objects,
    this.scenarios,
    this.schedules,
    this.waterTanks,
  });

  DataUser.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = new List<Device>();
      json['devices'].forEach((v) {
        devices.add(new Device.fromJson(v));
      });
    }
    email = json['email'];
    environmentLocation = json['environment_location'] != null
        ? new EnvironmentLocation.fromJson(json['environment_location'])
        : null;
    environmentName = json['environment_name'];
    // if (json['groups'] != null) {
    //   groups = new List<Null>();
    //   json['groups'].forEach((v) {
    //     groups.add(new Null.fromJson(v));
    //   });
    // }
    identityId = json['identity_id'];
    if (json['objects'] != null) {
      objects = new List<Null>();
      // json['objects'].forEach((v) {
      //   objects.add(new Null.fromJson(v));
      // });
    }
    if (json['scenarios'] != null) {
      scenarios = new List<Null>();
      // json['scenarios'].forEach((v) {
      //   scenarios.add(new Null.fromJson(v));
      // });
    }
    if (json['schedules'] != null) {
      schedules = new List<Schedule>();
      json['schedules'].forEach((v) {
        schedules.add(new Schedule.fromJson(v));
      });
    }
    if (json['water_tanks'] != null) {
      waterTanks = new List<WaterTank>();
      json['water_tanks'].forEach((v) {
        waterTanks.add(new WaterTank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    data['email'] = this.email;
    if (this.environmentLocation != null) {
      data['environment_location'] = this.environmentLocation.toJson();
    }
    data['environment_name'] = this.environmentName;
    if (this.groups != null) {
      data['groups'] = {}; //this.groups.map((v) => v.toJson()).toList();
    }
    data['identity_id'] = this.identityId;
    if (this.objects != null) {
      data['objects'] = {}; //this.objects.map((v) => v.toJson()).toList();
    }
    if (this.scenarios != null) {
      data['scenarios'] = {}; // this.scenarios.map((v) => v.toJson()).toList();
    }
    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    if (this.waterTanks != null) {
      data['water_tanks'] = this.waterTanks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaterTank {
  String label;
  String thingId;
  String broker;
  WaterTank(this.label, this.thingId, this.broker);

  WaterTank.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    thingId = json['thing_id'];
    broker = json['broker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['thing_id'] = this.thingId;
    data['broker'] = this.broker;
    return data;
  }
}

class Scenario {}

class Group {}

class Object {}

class Device {
  String label;
  String localId;
  String objectId;
  String pin;
  String remoteId;
  String type;

  Device(
      {this.label,
      this.localId,
      this.objectId,
      this.pin,
      this.remoteId,
      this.type});

  Device.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    localId = json['local_id'];
    objectId = json['object_id'];
    pin = json['pin'];
    remoteId = json['remote_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['local_id'] = this.localId;
    data['object_id'] = this.objectId;
    data['pin'] = this.pin;
    data['remote_id'] = this.remoteId;
    data['type'] = this.type;
    return data;
  }
}

class EnvironmentLocation {
  CommingAction commingAction;
  Coordinates coordinates;
  String distance;
  String functionStatus;
  CommingAction leavingAction;

  EnvironmentLocation(
      {this.commingAction,
      this.coordinates,
      this.distance,
      this.functionStatus,
      this.leavingAction});

  EnvironmentLocation.fromJson(Map<String, dynamic> json) {
    commingAction = json['comming_action'] != null
        ? new CommingAction.fromJson(json['comming_action'])
        : null;
    coordinates = json['coordinates'] != null
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
    distance = json['distance'];
    functionStatus = json['function_status'];
    leavingAction = json['leaving_action'] != null
        ? new CommingAction.fromJson(json['leaving_action'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commingAction != null) {
      data['comming_action'] = this.commingAction.toJson();
    }
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['distance'] = this.distance;
    data['function_status'] = this.functionStatus;
    if (this.leavingAction != null) {
      data['leaving_action'] = this.leavingAction.toJson();
    }
    return data;
  }
}

class CommingAction {
  String actionStatus;
  String scenarioName;

  CommingAction({this.actionStatus, this.scenarioName});

  CommingAction.fromJson(Map<String, dynamic> json) {
    actionStatus = json['action_status'];
    scenarioName = json['scenario_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_status'] = this.actionStatus;
    data['scenario_name'] = this.scenarioName;
    return data;
  }
}

class Coordinates {
  String latitude;
  String longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Schedule {
  List<ScheduleAction> scheduleAction;
  String scheduleId;
  String scheduleName;
  String scheduleState;
  String scheduleTime;
  String scheduleType;
  List<dynamic> scheduleWeek;

  Schedule(
      {this.scheduleAction,
      this.scheduleId,
      this.scheduleName,
      this.scheduleState,
      this.scheduleTime,
      this.scheduleType,
      this.scheduleWeek});

  Schedule.fromJson(Map<String, dynamic> json) {
    if (json['schedule_action'] != null) {
      scheduleAction = new List<ScheduleAction>();
      json['schedule_action'].forEach((v) {
        scheduleAction.add(new ScheduleAction.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.scheduleAction != null) {
      data['schedule_action'] =
          this.scheduleAction.map((v) => v.toJson()).toList();
    }
    data['schedule_id'] = this.scheduleId;
    data['schedule_name'] = this.scheduleName;
    data['schedule_state'] = this.scheduleState;
    data['schedule_time'] = this.scheduleTime;
    data['schedule_type'] = this.scheduleType;
    data['schedule_week'] = this.scheduleWeek;

    return data;
  }
}

class ScheduleAction {
  TockAction action;
  String type;

  ScheduleAction({this.action, this.type});

  ScheduleAction.fromJson(Map<String, dynamic> json) {
    action =
        json['action'] != null ? TockAction.fromJson(json['action']) : 'ACTION';
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.action != null) {
      data['action'] = this.action.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class TockAction {
  String actionId;
  String delay;
  String deviceId;
  String event;
  String label;
  String objectId;
  String section;
  String type;

  TockAction(
      {this.actionId,
      this.delay,
      this.deviceId,
      this.event,
      this.label,
      this.objectId,
      this.section,
      this.type});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_id'] = this.actionId;
    data['delay'] = this.delay;
    data['device_id'] = this.deviceId;
    data['event'] = this.event;
    data['label'] = this.label;
    data['object_id'] = this.objectId;
    data['section'] = this.section;
    data['type'] = this.type;
    return data;
  }
}
