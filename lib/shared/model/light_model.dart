import 'package:client/shared/model/data_user_model.dart';

class Light {
  Device? device;
  String? state;
  Light({this.device, this.state});

  Light.fromJson(Map<String, dynamic> json) {
    device = Device.fromJson(json['device']);
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['device'] = device?.toJson();
    return data;
  }
}
