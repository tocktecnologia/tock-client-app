// class ScheduleRecurrent {
//   List<ScheduleAction> scheduleAction;
//   String scheduleId;
//   String scheduleName;
//   String scheduleState;
//   String scheduleTime;
//   String scheduleType;
//   List<int> scheduleWeek;

//   ScheduleRecurrent(
//       {this.scheduleAction,
//       this.scheduleId,
//       this.scheduleName,
//       this.scheduleState,
//       this.scheduleTime,
//       this.scheduleType,
//       this.scheduleWeek});

//   ScheduleRecurrent.fromJson(Map<String, dynamic> json) {
//     if (json['schedule_action'] != null) {
//       scheduleAction = new List<ScheduleAction>();
//       json['schedule_action'].forEach((v) {
//         scheduleAction.add(new ScheduleAction.fromJson(v));
//       });
//     }
//     scheduleId = json['schedule_id'];
//     scheduleName = json['schedule_name'];
//     scheduleState = json['schedule_state'];
//     scheduleTime = json['schedule_time'];
//     scheduleType = json['schedule_type'];
//     scheduleWeek = json['schedule_week'].cast<int>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.scheduleAction != null) {
//       data['schedule_action'] =
//           this.scheduleAction.map((v) => v.toJson()).toList();
//     }
//     data['schedule_id'] = this.scheduleId;
//     data['schedule_name'] = this.scheduleName;
//     data['schedule_state'] = this.scheduleState;
//     data['schedule_time'] = this.scheduleTime;
//     data['schedule_type'] = this.scheduleType;
//     data['schedule_week'] = this.scheduleWeek;
//     return data;
//   }
// }

// class ScheduleAction {
//   TockAction action;
//   String type;

//   ScheduleAction({this.action, this.type});

//   ScheduleAction.fromJson(Map<String, dynamic> json) {
//     action =
//         json['action'] != null ? new TockAction.fromJson(json['action']) : null;
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.action != null) {
//       data['action'] = this.action.toJson();
//     }
//     data['type'] = this.type;
//     return data;
//   }
// }

// class TockAction {
//   String actionId;
//   String delay;
//   String deviceId;
//   String event;
//   String label;
//   String objectId;
//   String section;
//   String type;

//   TockAction(
//       {this.actionId,
//       this.delay,
//       this.deviceId,
//       this.event,
//       this.label,
//       this.objectId,
//       this.section,
//       this.type});

//   TockAction.fromJson(Map<String, dynamic> json) {
//     actionId = json['action_id'];
//     delay = json['delay'];
//     deviceId = json['device_id'];
//     event = json['event'];
//     label = json['label'];
//     objectId = json['object_id'];
//     section = json['section'];
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['action_id'] = this.actionId;
//     data['delay'] = this.delay;
//     data['device_id'] = this.deviceId;
//     data['event'] = this.event;
//     data['label'] = this.label;
//     data['object_id'] = this.objectId;
//     data['section'] = this.section;
//     data['type'] = this.type;
//     return data;
//   }
// }
