import 'dart:convert';

import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:client/shared/utils/conversions.dart';
import 'package:client/shared/utils/exceptions_tock.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AwsApiSchedules {
  Future<dynamic> createSchedule(Schedule schedule) async {
    // await Future.delayed(Duration(seconds: 1));
    final user =
        await Locator.instance.get<CognitoUserService>().getCurrentUser();
    final credentials =
        await Locator.instance.get<CognitoUserService>().getCredentials();

    final scheduleUtc = TockTime.scheduleLocal2Utc(schedule);
    final scheduleParam = jsonEncode(scheduleUtc.toJson());

    String url = 'https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com';
    String body =
        '{"identity_id":"${credentials?.userIdentityId}","environment_name":"${user?.locale}","schedule_infos":[$scheduleParam]}';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "auth": (credentials?.sessionToken)!
    };

    final response = await post(
            Uri.https(url, '${Endpoints.STAGE}/user/schedules/create2'),
            headers: headers,
            body: body)
        .timeout(const Duration(seconds: 15));
    final Map reponseJson = jsonDecode(response.body);
    print(reponseJson);
    if (reponseJson.containsKey('errorMessage')) {
      print('reponseJson.containsKey(errorMessage)');
      throw ApiGatewayException(
        hasTimeout: false,
        message: 'Erro criando agendamento',
      );
    } else {
      if (reponseJson['retorno'] == 'sucesso') {
        return reponseJson['message'];
      } else
        throw ApiGatewayException(
            hasTimeout: false, message: 'Erro criando agendamento');
    }
  }

  // Future<dynamic> deleteSchedule(Schedule schedule) async {
  //   // await Future.delayed(Duration(seconds: 1));
  //   final locale = Locator.instance.get<UserCognito>().userAttrs['locale'];
  //   final identityId = await Cognito.getIdentityId();
  //   Tokens tokens = await Cognito.getTokens();

  //   String url =
  //       'https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com/${Endpoints.STAGE}/user/schedules/delete';
  //   String body =
  //       '{"identity_id":"$identityId","environment_name":"$locale","schedule_id":${schedule.scheduleId}}';
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "auth": tokens.idToken
  //   };

  //   final response = await post(url, headers: headers, body: body)
  //       .timeout(Duration(seconds: 15));
  //   final reponseJson = jsonDecode(response.body);
  //   if (reponseJson.containsKey('errorMessage') ||
  //       reponseJson.containsKey('message')) {
  //     throw ApiGatewayException(
  //       hasTimeout: false,
  //       message: 'Erro criando agendamento',
  //     );
  //   } else if (reponseJson.containsKey('retorno')) {
  //     if (reponseJson['retorno'] == 'sucesso') {
  //       return reponseJson['mensagem'] ?? 'não possui o campo mensagem';
  //     } else {
  //       throw Exception(reponseJson['mensagem'] ?? 'retorno em sucesso');
  //     }
  //   }
  // }

  // Future<dynamic> updateSchedule(
  //     {@required Schedule schedule, newState}) async {
  //   // await Future.delayed(Duration(seconds: 1));
  //   final locale = Locator.instance.get<UserCognito>().userAttrs['locale'];
  //   final identityId = await Cognito.getIdentityId();
  //   Tokens tokens = await Cognito.getTokens();

  //   // convert to utc
  //   final scheduleUtc = TockTime.scheduleLocal2Utc(schedule);

  //   // change state if newState not null
  //   var scheduleJson = scheduleUtc.toJson();
  //   scheduleJson['schedule_state'] = newState ?? scheduleJson['schedule_state'];
  //   final scheduleParam = jsonEncode(scheduleJson);

  //   String url =
  //       'https://9cw57hx4ja.execute-api.us-east-1.amazonaws.com/${Endpoints.STAGE}/user/schedules/updatefull';
  //   String body =
  //       '{"identity_id":"$identityId","environment_name":"$locale","schedule_update":$scheduleParam}';
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "auth": tokens.idToken
  //   };

  //   final response = await post(url, headers: headers, body: body)
  //       .timeout(Duration(seconds: 15));
  //   final reponseJson = jsonDecode(response.body);

  //   if (reponseJson.containsKey('errorMessage') ||
  //       reponseJson.containsKey('message')) {
  //     print('ApiGatewayException');
  //     throw ApiGatewayException(
  //       hasTimeout: false,
  //       message: 'Erro atualizando agendamento',
  //     );
  //   } else {
  //     if (reponseJson['retorno'] == 'sucesso') {
  //       return reponseJson['mensagem'] ?? 'não possui o campo mensagem';
  //     } else {
  //       throw Exception(reponseJson['mensagem'] ?? 'sem campo mensagem');
  //     }
  //   }
  // }
}
