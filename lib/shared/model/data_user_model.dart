class DataUser {
  List<Device> devices;
  List<Groups> groups;
  List<Scenes> scenes;
  List<Schedule> schedules;

  DataUser({this.devices, this.groups, this.scenes, this.schedules});

  DataUser.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = new List<Device>();
      json['devices'].forEach((v) {
        devices.add(new Device.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
    if (json['scenes'] != null) {
      scenes = new List<Scenes>();
      json['scenes'].forEach((v) {
        scenes.add(new Scenes.fromJson(v));
      });
    }
    if (json['schedules'] != null) {
      schedules = new List<Schedule>();
      json['schedules'].forEach((v) {
        schedules.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    if (this.scenes != null) {
      data['scenes'] = this.scenes.map((v) => v.toJson()).toList();
    }
    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Device {
  String remoteId;
  String localId;
  String pin;
  String objectId;
  String label;
  String type;

  Device(
      {this.remoteId,
      this.localId,
      this.pin,
      this.objectId,
      this.label,
      this.type});

  Device.fromJson(Map<String, dynamic> json) {
    remoteId = json['remote_id'];
    localId = json['local_id'];
    pin = json['pin'];
    objectId = json['object_id'];
    label = json['label'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remote_id'] = this.remoteId;
    data['local_id'] = this.localId;
    data['pin'] = this.pin;
    data['object_id'] = this.objectId;
    data['label'] = this.label;
    data['type'] = this.type;
    return data;
  }
}

class Groups {
  String label;
  String groupId;
  List<String> objectIds;

  Groups({this.label, this.groupId, this.objectIds});

  Groups.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    groupId = json['group_id'];
    objectIds = json['object_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['group_id'] = this.groupId;
    data['object_ids'] = this.objectIds;
    return data;
  }
}

class Scenes {
  String sceneId;
  String label;
  List<String> objectIds;

  Scenes({this.sceneId, this.label, this.objectIds});

  Scenes.fromJson(Map<String, dynamic> json) {
    sceneId = json['scene_id'];
    label = json['label'];
    objectIds = json['object_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scene_id'] = this.sceneId;
    data['label'] = this.label;
    data['object_ids'] = this.objectIds;
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
  List<int> scheduleWeek;

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
    scheduleId = json['schedule_id'];
    scheduleName = json['schedule_name'];
    scheduleState = json['schedule_state'];
    scheduleTime = json['schedule_time'];
    scheduleType = json['schedule_type'];
    scheduleWeek = json['schedule_week'].cast<int>();
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
  Action action;
  String type;

  ScheduleAction({this.action, this.type});

  ScheduleAction.fromJson(Map<String, dynamic> json) {
    action =
        json['action'] != null ? new Action.fromJson(json['action']) : null;
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

class Action {
  String actionId;
  String delay;
  String deviceId;
  String event;
  String label;
  String objectId;
  String section;
  String type;

  Action(
      {this.actionId,
      this.delay,
      this.deviceId,
      this.event,
      this.label,
      this.objectId,
      this.section,
      this.type});

  Action.fromJson(Map<String, dynamic> json) {
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
