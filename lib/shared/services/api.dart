import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';

class AwsApi {
  Future<DataUser> getDataUser() async {
    // final filepath2 = '../../../mock/data.json';
    final filepath =
        'package:flutter_login_setup_cognito/mocks/data-users.json';
    Map x = json.decode(await File(filepath).readAsString());
    print(x);
  }
}
