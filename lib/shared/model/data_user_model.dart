class DataUser {
  List<Device> devices;
  List<Group> groups;
  List<Scene> scenes;

  DataUser({this.devices, this.groups, this.scenes});

  DataUser.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = new List<Device>();
      json['devices'].forEach((v) {
        devices.add(new Device.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = new List<Group>();
      json['groups'].forEach((v) {
        groups.add(new Group.fromJson(v));
      });
    }
    if (json['scenes'] != null) {
      scenes = new List<Scene>();
      json['scenes'].forEach((v) {
        scenes.add(new Scene.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    print("entrei em toJson");
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

class Device {
  String remoteId;
  String localId;
  String objectId;
  String label;
  String type;
  String pin;

  Device(
      {this.remoteId,
      this.localId,
      this.objectId,
      this.label,
      this.type,
      this.pin});

  Device.fromJson(Map<String, dynamic> json) {
    remoteId = json['remote_id'];
    localId = json['local_id'];
    objectId = json['object_id'];
    label = json['label'];
    type = json['type'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remote_id'] = this.remoteId;
    data['local_id'] = this.localId;
    data['object_id'] = this.objectId;
    data['label'] = this.label;
    data['type'] = this.type;
    data['pin'] = this.pin;
    return data;
  }
}

class Group {
  String label;
  String groupId;
  List<String> objectIds;

  Group({this.label, this.groupId, this.objectIds});

  Group.fromJson(Map<String, dynamic> json) {
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

class Scene {
  String sceneId;
  String label;
  List<String> objectIds;

  Scene({this.sceneId, this.label, this.objectIds});

  Scene.fromJson(Map<String, dynamic> json) {
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
