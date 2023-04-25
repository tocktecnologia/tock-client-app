import 'dart:convert';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:client/shared/utils/exceptions_tock.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:http/http.dart';

class AwsApi {
  Future<DataUser> getDataUser() async {
    final user =
        await Locator.instance.get<CognitoUserService>().getCurrentUser();
    final credentials =
        await Locator.instance.get<CognitoUserService>().getCredentials();

    String url = '9cw57hx4ja.execute-api.us-east-1.amazonaws.com';

    String body =
        '{"email":"${user?.email}","identity_id":"${credentials?.userIdentityId}","environment_name":"${user?.locale}"}';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "auth": '${credentials?.sessionToken}'
    };

    //try {
    final response = await post(Uri.https(url, '${Endpoints.STAGE}/user'),
            headers: headers, body: body)
        .timeout(const Duration(seconds: 15));

    final Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (responseJson['Message'] == "Unauthorized" ||
        responseJson['Message'] == "Access Denied") {
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
