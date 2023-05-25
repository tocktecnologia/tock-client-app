import 'package:client/shared/services/api/user_aws.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/services/dotenv_service.dart';
import 'package:get_it/get_it.dart';

class Locator {
  static GetIt _i = GetIt.I;
  static GetIt get instance => _i;

  Locator.setup() {
    _i = GetIt.I;

    _i.registerSingleton<MqttService>(MqttService());

    _i.registerSingleton<CognitoUserService>(CognitoUserService());

    // _i.registerSingleton<FirmwareApi>(FirmwareApi());

    // _i.registerSingleton<AwsIot>(AwsIot());

    _i.registerSingleton<AwsApi>(AwsApi());
    // _i.registerLazySingleton<AwsApiSchedules>(() => AwsApiSchedules());
  }
}
