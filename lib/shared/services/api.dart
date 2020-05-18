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
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "1",
      "object_id": "123",
      "label": "Lampadas da Saída 1",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "2",
      "object_id": "123",
      "label": "Lampadas da Saída 2",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "3",
      "object_id": "123",
      "label": "Lampadas da Saída 3",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "4",
      "object_id": "123",
      "label": "Lampadas da Saída 4",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "5",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "6",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "7",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "8",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "9",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "11",
      "object_id": "123",
      "label": "Lampadas da Saída",
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
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "13",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "14",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "15",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "pin": "16",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
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
  ]
};
