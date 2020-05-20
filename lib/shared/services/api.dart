import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';

class AwsApi {
  Future<DataUser> getDataUser() async {
    await Future.delayed(Duration(milliseconds: 1000));
    print('lendo json');
    DataUser u = DataUser.fromJson(dataUserJson);
    print(u.toString());
    return u;
  }
}

final dataUserJson = {
  "devices": [
    {
      "remote_id": "E821C76A",
      "local_id": "10.0.1.10",
      "pin": "1",
      "object_id": "123",
      "label": "E821C76A 1",
      "type": "LIGHT"
    },
    {
      "remote_id": "E821C76A",
      "local_id": "10.0.1.10",
      "pin": "2",
      "object_id": "123",
      "label": "E821C76A 2",
      "type": "LIGHT"
    },
    {
      "remote_id": "E821C76A",
      "local_id": "10.0.1.10",
      "pin": "3",
      "object_id": "123",
      "label": "E821C76A 3",
      "type": "LIGHT"
    },
    {
      "remote_id": "E821C76A",
      "local_id": "10.0.1.10",
      "pin": "4",
      "object_id": "123",
      "label": "E821C76A 4",
      "type": "LIGHT"
    },
    {
      "remote_id": "E821C76A",
      "local_id": "10.0.1.10",
      "pin": "5",
      "object_id": "123",
      "label": "E821C76A 5",
      "type": "LIGHT"
    },
    {
      "remote_id": "E821C76A",
      "local_id": "10.0.1.10",
      "pin": "6",
      "object_id": "123",
      "label": "E821C76A 6",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "12",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    // {
    //   "remote_id": "9F3A1234",
    //   "local_id": "10.0.1.10",
    //   "pin": "13",
    //   "object_id": "123",
    //   "label": "Lampadas da Saída",
    //   "type": "LIGHT"
    // },
    // {
    //   "remote_id": "9F3A1234",
    //   "local_id": "10.0.1.10",
    //   "pin": "14",
    //   "object_id": "123",
    //   "label": "Lampadas da Saída",
    //   "type": "LIGHT"
    // },
    // {
    //   "remote_id": "9F3A1234",
    //   "local_id": "10.0.1.10",
    //   "pin": "15",
    //   "object_id": "123",
    //   "label": "Lampadas da Saída",
    //   "type": "LIGHT"
    // },
    // {
    //   "remote_id": "9F3A1234",
    //   "local_id": "10.0.1.10",
    //   "pin": "16",
    //   "object_id": "123",
    //   "label": "Lampadas da Saída",
    //   "type": "LIGHT"
    // },
  ],
  "groups": [
    {
      "label": "Quadra",
      "group_id": "abcd",
      "object_ids": ["1234567", "12345678"]
    },
    {
      "label": "Academia",
      "group_id": "abc",
      "object_ids": ["1234", "12345"]
    }
  ],
  "scenes": [
    {
      "scene_id": "abc123",
      "label": "desligadar quadra e academia",
      "object_ids": ["1234", "12345", "123456", "123457"]
    }
  ],
  "schedules": [
    {
      "schedule_action": [
        {
          "action": {
            "action_id": "9ba55f94-9876-4217-8f09-6c1c5edc2a86",
            "delay": "0",
            "device_id": "E821C76A",
            "event": "1",
            "label": "Luz Fora",
            "object_id": "E821C76A-1",
            "section": "1",
            "type": "LIGHT"
          },
          "type": "ACTION"
        }
      ],
      "schedule_id": "3c3e2aa9-a09e-4679-b0fb-cad4103e0172",
      "schedule_name": "ligar luz fora",
      "schedule_state": "ENABLED",
      "schedule_time": "20:45",
      "schedule_type": "RECURRENT",
      "schedule_week": [0, 1, 2, 3, 4, 5, 6]
    },
    {
      "schedule_action": [
        {
          "action": {
            "action_id": "e6760037-a983-4b58-8456-aed72b0acc55",
            "delay": "0",
            "device_id": "E821C76A",
            "event": "0",
            "label": "Luz Fora",
            "object_id": "E821C76A-1",
            "section": "1",
            "type": "LIGHT"
          },
          "type": "ACTION"
        }
      ],
      "schedule_id": "ca8a6199-cff8-4e61-98e6-cde7ff7192c0",
      "schedule_name": "desl luz fora",
      "schedule_state": "ENABLED",
      "schedule_time": "02:00",
      "schedule_type": "RECURRENT",
      "schedule_week": [1, 2, 3, 4, 5, 6, 0]
    }
  ]
};
