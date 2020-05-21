import 'package:aws_iot/aws_iot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_event.dart';
import 'package:flutter_login_setup_cognito/bloc/light/light_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:flutter_login_setup_cognito/shared/utils/screen_transitions/fade.transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:reorderables/reorderables.dart';

import 'light.dart';

const PADDING_HORIZ_INTERN = 10.0;
const PADDING_HORIZ_EXTERN = 10.0;
const NUM_LAMPS_ROW = 3;

class PanelScreen extends StatefulWidget {
  @override
  _PanelScreenState createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  bool isConfigMode = false;

  @override
  void initState() {
    super.initState();

    final AWSIotDevice awsIotDevice =
        Locator.instance.get<AwsIot>().awsIotDevice;
    awsIotDevice.client.updates.listen((_) {
      _onReceive(awsIotDevice, BlocProvider.of<LightBloc>(context));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateStates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel"),
        actions: [_iconLocal()],
        leading: _iconRemote(),
        centerTitle: true,
      ),
      body: _cardLights(),
    );
  }

  // listinning from aws mqtt
  _onReceive(awsIotDevice, lightBloc) async {
    final lastMsg = await awsIotDevice.messages.elementAt(0);
    print(lastMsg);
    // verify if is aws shadow message
    if (lastMsg.asJson.containsKey('state')) {
      if (lastMsg.asJson['state'].containsKey('reported')) {
        final deviceId = lastMsg.topic.split('/')[2];
        lastMsg.asJson['state']['reported'].forEach((k, v) {
          //print("deviceid: $deviceId, pin${k[3]} ---->  $v");
          BlocProvider.of<LightBloc>(context).add(ReceiveUpdateLightEvent(
              deviceId: deviceId, pin: k[3], state: v.toString()));
        });
      }
    } else if (lastMsg.asJson.containsKey('states')) {
      BlocProvider.of<LightsBloc>(context).add(
          UpdateLightsFromCentralEvent(statesJson: lastMsg.asJson['states']));
    }
  }

  Widget _cardLights() {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: PADDING_HORIZ_EXTERN, vertical: 20),
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: isConfigMode ? Colors.grey.shade200 : Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: ColorsCustom.loginScreenMiddle,
                  blurRadius: 4,
                  spreadRadius: 0.5),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () => setState(() => isConfigMode = !isConfigMode),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Icon(
                        isConfigMode ? Icons.keyboard_return : Icons.mode_edit,
                        size: 20,
                        color: ColorsCustom.loginScreenUp,
                      ),
                    ),
                  ),
                  Text(
                    "Iluminação",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorsCustom.loginScreenMiddle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _updateStates(),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Icon(
                          Icons.update,
                          size: 27,
                          color: ColorsCustom.loginScreenUp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 0)),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
                  child: _lights()),
            ],
          ),
        ),
      ),
    );
  }

  _updateStates() {
    print('_updateStates()');
    // // verrify connection mqtt
    final AwsIot awsIot = Locator.instance.get<AwsIot>();
    final status = awsIot.awsIotDevice.client.connectionStatus.state;
    if (status == MqttConnectionState.disconnected) {
      print('disconnected , do event ...');
      BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
      Navigator.pushReplacement(context, FadeRoute(page: LoginScreen()));
    } else {
      print('publishing');
      // awsIot.awsIotDevice.publishJson({}, topic: MqttTopics.getStates);
      awsIot.awsIotDevice.publishJson({"estados": "000,160"},
          topic: '\$aws/things/${Central.remoteId}/states');
    }
  }

  Widget _lights() {
    return BlocBuilder<LightsBloc, LightsState>(
      builder: (context, state) {
        if (state is UpdatingDevicesState ||
            state is UpdatingDevicesFromAwsState) {
          return Center(
            child: SpinKitRipple(
              size: 30,
              color: ColorsCustom.loginScreenUp,
            ),
          );
        } else if (state is UpdatedDevicesState) {
          if (state.lights.isEmpty)
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text('Você possui dispositivos ainda!'),
            );
          else {
            print('rebuild _listWrapReorderable');
            return _listWrapReorderable();
          }
        } else
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('Você ainda não confgurou seus dispositivos!'),
          );
      },
    );
  }

  Widget _listWrapReorderable() {
    final lights = BlocProvider.of<LightsBloc>(context).lights;
    final tockLights = lights
        .map<TockLight>(
            (light) => TockLight(light: light, isConfigMode: isConfigMode))
        .toList();

    return ReorderableWrap(
      spacing: (MediaQuery.of(context).size.width -
              3 * SIZE_WIDTH_LAMP -
              2 * PADDING_HORIZ_EXTERN -
              2 * PADDING_HORIZ_INTERN) /
          (NUM_LAMPS_ROW - 1),
      runSpacing: 20,
      padding: EdgeInsets.only(top: 20, bottom: 10),
      children: tockLights,
      onReorder: _onReorder,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    final lights = BlocProvider.of<LightsBloc>(context).lights;
    final w = lights.removeAt(oldIndex);
    lights.insert(newIndex, w);
    BlocProvider.of<LightsBloc>(context).setLights(lights);
    setState(() {});
  }

  Widget _iconRemote() {
    return BlocProvider.of<AuthBloc>(context).isConnectedRemote
        ? Icon(Icons.cloud_done, color: Colors.white)
        : Icon(Icons.cloud_off, color: Colors.white30);
  }

  Widget _iconLocal() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: BlocProvider.of<AuthBloc>(context).isConnectedLocal
            ? Icon(Icons.wifi_tethering, color: Colors.white)
            : Icon(Icons.portable_wifi_off, color: Colors.white30));
  }
}
