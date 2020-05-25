import 'package:flutter_login_setup_cognito/shared/services/api/schedules_aws.dart';
import 'package:flutter_login_setup_cognito/shared/services/api/user_aws.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:get_it/get_it.dart';

class Locator {
  static GetIt _i;
  static GetIt get instance => _i;

  Locator.setup() {
    _i = GetIt.I;

    _i.registerSingleton<UserCognito>(UserCognito());

    _i.registerSingleton<FirmwareApi>(FirmwareApi());

    _i.registerSingleton<AwsIot>(AwsIot());

    _i.registerSingleton<AwsApi>(AwsApi());
    _i.registerLazySingleton<AwsApiSchedules>(() => AwsApiSchedules());
  }
}
