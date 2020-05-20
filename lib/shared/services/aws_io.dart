import 'package:aws_iot/aws_iot.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:uuid/uuid.dart';

class AwsIot {
  AWSIotDevice _awsIotDevice;
  get awsIotDevice => _awsIotDevice;

  Future intialize() async {
    Uuid uuid = Uuid();
    final id = '${uuid.v4()}';
    if (!await Cognito.isSignedIn()) return;

    _awsIotDevice = AWSIotDevice(
      endpoint: 'a33yv9okseqbmj-ats.iot.us-east-1.amazonaws.com',
      clientId: '$id',
    );

    final identityId = await Cognito.getIdentityId();
    print('connecting ... \nidentityId: $identityId');

    await _awsIotDevice.connect().timeout(Duration(seconds: 10));

    _subscribing();
  }

  _subscribing() {
    print('conectou abestado, subscribing ...!!!');
    final shadow = '\$aws/things/${Central.remoteId}/shadow/update/accepted';
    final states = '\$aws/things/${Central.remoteId}/states';
    print('shadow:$shadow \nstate:$states');
    _awsIotDevice.subscribe(shadow);
    _awsIotDevice.subscribe(states);
  }
}
