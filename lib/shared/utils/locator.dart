import 'package:flutter_login_setup_cognito/shared/services/api.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/services/wifi.dart';
import 'package:get_it/get_it.dart';

class Locator {
  static GetIt _i;
  static GetIt get instance => _i;

  Locator.setup() {
    _i = GetIt.I;

    _i.registerSingleton<UserCognito>(UserCognito());

    _i.registerSingleton<FirmwareApi>(FirmwareApi());

    _i.registerSingleton<AwsApi>(AwsApi());

    _i.registerSingleton<WifiService>(WifiService());
  }
}
