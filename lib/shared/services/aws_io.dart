import 'package:aws_iot/aws_iot.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/exceptions_tock.dart';
import 'package:uuid/uuid.dart';

class AwsIot {
  AWSIotDevice _awsIotDevice;
  get awsIotDevice => _awsIotDevice;

  Future<bool> intialize() async {
    Uuid uuid = Uuid();
    final id = '${uuid.v4()}';
    if (!await Cognito.isSignedIn()) return false;

    _awsIotDevice = AWSIotDevice(
      endpoint: 'a33yv9okseqbmj-ats.iot.us-east-1.amazonaws.com',
      clientId: '$id',
    );

    final identityId = await Cognito.getIdentityId();
    print('connecting ... \nidentityId: $identityId');

    await _awsIotDevice.connect().timeout(Duration(seconds: 5)).catchError(
        (onError) => throw IotAwsException(
            hasTimeout: true, message: "Timeout 10s", type: "conexao"));

    _subscribing();

    return true;
  }

  _subscribing() {
    print('conectou abestado, subscribing ...!!!');

    print(
        'shadowUpdated:${MqttTopics.shadowUpdateAccepted} \ngetShadow:${MqttTopics.shadowGetAccepted}');
    _awsIotDevice.subscribe(MqttTopics.shadowUpdateAccepted);
    _awsIotDevice.subscribe(MqttTopics.shadowGetAccepted);
    _awsIotDevice.subscribe('${MqttTopics.getStates}/ret');
  }
}
