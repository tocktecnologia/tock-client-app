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
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234",
      "local_id": "10.0.1.10",
      "object_id": "123",
      "label": "Lampadas da Saída",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A12345",
      "local_id": "10.0.1.11",
      "object_id": "1234",
      "label": "Lampada da Quadra 1",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A123456",
      "local_id": "10.0.1.12",
      "object_id": "12345",
      "label": "Lampada da Quadra 2",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A1234567",
      "local_id": "10.0.1.13",
      "object_id": "123456",
      "label": "Lampada da academia 1",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A12345678",
      "local_id": "10.0.1.14",
      "object_id": "1234567",
      "label": "Lampada da academia 2",
      "type": "LIGHT"
    },
    {
      "remote_id": "9F3A123456789",
      "local_id": "10.0.1.15",
      "object_id": "12345678",
      "label": "Lampadas  do Hall",
      "type": "LIGHTS"
    }
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
