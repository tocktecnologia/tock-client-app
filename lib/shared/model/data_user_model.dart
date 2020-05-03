class DataUser {
  List<Devices> devices;
  List<Groups> groups;
  List<Scenes> scenes;

  DataUser({this.devices, this.groups, this.scenes});

  DataUser.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = new List<Devices>();
      json['devices'].forEach((v) {
        devices.add(new Devices.fromJson(v));
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
    return data;
  }
}

class Devices {
  String remoteId;
  String localId;
  String objectId;
  String label;
  String type;

  Devices({this.remoteId, this.localId, this.objectId, this.label, this.type});

  Devices.fromJson(Map<String, dynamic> json) {
    remoteId = json['remote_id'];
    localId = json['local_id'];
    objectId = json['object_id'];
    label = json['label'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remote_id'] = this.remoteId;
    data['local_id'] = this.localId;
    data['object_id'] = this.objectId;
    data['label'] = this.label;
    data['type'] = this.type;
    return data;
  }
}

class Groups {
  String label;
  String groupId;
  List<String> moduleIds;
  List<String> deviceIds;

  Groups({this.label, this.groupId, this.moduleIds, this.deviceIds});

  Groups.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    groupId = json['group_id'];
    moduleIds = json['module_ids'].cast<String>();
    deviceIds = json['device_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['group_id'] = this.groupId;
    data['module_ids'] = this.moduleIds;
    data['device_ids'] = this.deviceIds;
    return data;
  }
}

class Scenes {
  String sceneId;
  String label;
  List<String> deviceIds;

  Scenes({this.sceneId, this.label, this.deviceIds});

  Scenes.fromJson(Map<String, dynamic> json) {
    sceneId = json['scene_id'];
    label = json['label'];
    if (json['device_ids'] != null) {
      deviceIds = new List<String>();
      json['device_ids'].forEach((v) {
        deviceIds.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scene_id'] = this.sceneId;
    data['label'] = this.label;
    if (this.deviceIds != null) {
      data['device_ids'] = this.deviceIds.map((v) => v).toList();
    }
    return data;
  }
}
