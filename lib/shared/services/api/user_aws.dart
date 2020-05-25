import 'dart:convert';

import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/exceptions_tock.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:http/http.dart';

class AwsApi {
  Future<DataUser> getDataUser() async {
    final email = Locator.instance.get<UserCognito>().userAttrs['email'];
    final locale = Locator.instance.get<UserCognito>().userAttrs['locale'];
    final identityId = await Cognito.getIdentityId();
    Tokens tokens = await Cognito.getTokens();

    print('size id token: ${tokens.idToken.length}');
    print('id token: ${tokens.idToken}');

    String url =
        'https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com/${Endpoints.STAGE}/user';

    String body =
        '{"email":"$email","identity_id":"$identityId","environment_name":"$locale"}';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "auth": '${tokens.idToken}'
    };

    //try {
    final response = await post(url, headers: headers, body: body)
        .timeout(Duration(seconds: 15));

    final Map responseJson = jsonDecode(response.body);
    print(responseJson);

    if (responseJson['Message'] == "Unauthorized" ||
        responseJson['Message'] == "Access Denied") {
      print('entrei throw ApiGatewayException');
      throw ApiGatewayException(
        hasTimeout: false,
        message: "Usuário não autorizado",
      );
    } else {
      DataUser dataUser = DataUser.fromJson(responseJson);
      // dataUser.schedules = List<Schedule>();
      return dataUser;
    }
  }
}
