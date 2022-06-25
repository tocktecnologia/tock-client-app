import 'package:aws_iot/aws_iot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_event.dart';
import 'package:flutter_login_setup_cognito/bloc/central/central_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/iot_aws/iot_aws_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/light/light_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/local_network/local_network_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:flutter_login_setup_cognito/shared/utils/screen_transitions/size.transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:reorderables/reorderables.dart';

import 'device.dart';

const PADDING_HORIZ_INTERN = 10.0;
const PADDING_HORIZ_EXTERN = 10.0;
const NUM_LAMPS_ROW = 4;

class PanelScreen extends StatefulWidget {
  @override
  _PanelScreenState createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  bool isConfigMode = false;
  bool isLocalEnabled = false;
  @override
  void initState() {
    super.initState();
    isLocalEnabled = BlocProvider.of<LocalConfigBloc>(context).state.value;
  }

  // listinning from aws mqtt
  _onReceive(awsIotDevice) async {
    final AWSIotMsg lastMsg = await awsIotDevice.messages.elementAt(0);
    print('_onReceive: \ntopic: ${lastMsg.topic}; \nmsg: ${lastMsg.asStr}\n\n');

    // verify if is aws shadow message and topic update
    if (lastMsg.asJson.containsKey('state') &&
        (lastMsg.topic == MqttTopics.shadowUpdateAccepted ||
            lastMsg.topic == MqttTopics.tockUpdateReturn)) {
      // verify if exist reported
      if (lastMsg.asJson['state'].containsKey('reported')) {
        final deviceId = lastMsg.topic.split('/')[2];
        lastMsg.asJson['state']['reported'].forEach((k, v) {
          //print("deviceid: $deviceId, pin${k[3]} ---->  $v");
          BlocProvider.of<LightBloc>(context).add(ReceiveUpdateLightEvent(
              deviceId: deviceId, pin: k.substring(3), state: v.toString()));
        });
      }
    } else if (lastMsg.asJson.containsKey('state') &&
        lastMsg.topic == MqttTopics.getStatesFromCentral) {
      final lights = BlocProvider.of<LightsBloc>(context).lights;
      print(
          'Message receive on ${MqttTopics.getStatesFromCentral}: ${lastMsg.asJson['state']}');
      BlocProvider.of<IotAwsBloc>(context).add(UpdateLightsFromNodeCentralEvent(
          statesJson: lastMsg.asJson['state'], lights: lights));
      //
    } else if (lastMsg.asJson.containsKey('state') &&
        lastMsg.topic == MqttTopics.shadowGetAccepted) {
      print(
          'Message receive on ${MqttTopics.shadowGetAccepted}: ${lastMsg.asJson}');
      final lights = BlocProvider.of<LightsBloc>(context).lights;
      BlocProvider.of<IotAwsBloc>(context).add(UpdateLightsFromShadowEvent(
          statesJson: lastMsg.asJson['state'], lights: lights));
    }
  }

  _updateStates() {
    if (isLocalEnabled) {
      final lights = BlocProvider.of<LightsBloc>(context).lights;
      BlocProvider.of<CentralBloc>(context)
          .add(GetUpdateLightsFromCentralEvent(lights: lights));
    } else {
      final AwsIot awsIot = Locator.instance.get<AwsIot>();
      final status = awsIot.awsIotDevice.client.connectionStatus.state;
      print('status connection : $status');
      print('_updateStatesFromShadow()');
      if (status == MqttConnectionState.connected) {
        BlocProvider.of<IotAwsBloc>(context)
            .add(GetUpdateLightsFromShadowEvent());
        // BlocProvider.of<IotAwsBloc>(context)
        //     .add(GetUpdateLightsFromNodeCentralEvent());
      } else if (status == MqttConnectionState.disconnected) {
        BlocProvider.of<IotAwsBloc>(context).add(ConnectIotAwsEvent());
        BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
        Navigator.pushReplacement(context, SizeRoute(page: LoginScreen()));
      }
    }
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
                    "Dispositivos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorsCustom.loginScreenMiddle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  _updateButton()
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 0)),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
                  child: _panelLights()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelLights() {
    return BlocBuilder<LightsBloc, LightsState>(
      builder: (context, state) {
        if (state is UpdatingDevicesState ||
            state is UpdatingDevicesFromAwsState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child:
                    SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
              ),
              SizedBox(height: 20),
              Text("Recuperando Estados  ... ",
                  style: TextStyle(
                      fontSize: 17, color: ColorsCustom.loginScreenUp)),
            ],
          );
        } else if (state is UpdatedDevicesState) {
          if (!isLocalEnabled) {
            return iotConnectionDevices(state);
          } else {
            print('asking central...');
            return centralConnectionDevices(state);
          }
        } else
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('Você ainda não confgurou seus dispositivos!'),
          );
      },
    );
  }

  Widget centralConnectionDevices(UpdatedDevicesState stateLights) {
    BlocProvider.of<CentralBloc>(context)
        .add(GetUpdateLightsFromCentralEvent(lights: stateLights.lights));

    return BlocBuilder<CentralBloc, CentralState>(
      condition: (prevState, state) {
        if (state is UpdateLightsFromCentralErrorState) {
          ShowAlert.open(context: context, contentText: state.message);
        }
        return;
      },
      builder: (context, state) {
        if (state is UpdatingLightsFromCentralState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child:
                    SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("Atualizando estados da central... ",
                    style: TextStyle(
                        fontSize: 17, color: ColorsCustom.loginScreenUp)),
              ),
            ],
          );
        } else {
          return _listWrapReorderable(stateLights);
        }
      },
    );
  }

  Widget iotConnectionDevices(stateLights) {
    return BlocBuilder<IotAwsBloc, IotAwsState>(condition: (prevState, state) {
      if (state is ConnectedIotAwsState) {
        // init listenning aws iot if not local choiced
        final AWSIotDevice awsIotDevice =
            Locator.instance.get<AwsIot>().awsIotDevice;
        awsIotDevice.client.updates.listen((_) {
          _onReceive(awsIotDevice);
        });
        _updateStates();
      }
      return;
    }, builder: (context, state) {
      if (state is ConnectingIotAwsState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Conectando ao sistema ... ",
                  style: TextStyle(
                      fontSize: 17, color: ColorsCustom.loginScreenUp)),
            ),
          ],
        );
      } else if (state is ConnectedIotAwsState ||
          state is UpdatingLightsFromShadowState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Atualizando estados da nuvem... ",
                  style: TextStyle(
                      fontSize: 17, color: ColorsCustom.loginScreenUp)),
            ),
          ],
        );
      } else {
        return _listWrapReorderable(stateLights);
      }
    });
  }

  Widget _updateButton() {
    return BlocBuilder<IotAwsBloc, IotAwsState>(builder: (context, state) {
      if (state is ConnectingIotAwsState)
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child:
              SpinKitThreeBounce(color: ColorsCustom.loginScreenUp, size: 20),
        );
      else
        return _icon();
    });
  }

  Widget _icon() {
    return BlocBuilder<LightsBloc, LightsState>(builder: (context, state) {
      if (state is UpdatingDevicesState) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child:
              SpinKitThreeBounce(color: ColorsCustom.loginScreenUp, size: 20),
        );
      } else
        return InkWell(
          onTap: () => _updateStates(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child:
                Icon(Icons.update, size: 27, color: ColorsCustom.loginScreenUp),
          ),
        );
    });
  }

  Widget _listWrapReorderable(state) {
    // final lights = BlocProvider.of<LightsBloc>(context).lights;
    final tockLights = state.lights
        .map<TockDevice>(
            (light) => TockDevice(light: light, isConfigMode: isConfigMode))
        .toList();

    return ReorderableWrap(
      spacing: (MediaQuery.of(context).size.width -
              NUM_LAMPS_ROW * SIZE_WIDTH_LAMP -
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
    // get lights
    final lights = BlocProvider.of<LightsBloc>(context).lights;

    // change index
    final w = lights.removeAt(oldIndex);
    lights.insert(newIndex, w);

    // update  lights in bloc
    BlocProvider.of<LightsBloc>(context).setLights(lights);

    //update view
    setState(() {});
  }

  Widget _iconRemote() {
    return BlocProvider.of<AuthBloc>(context).isConnectedRemote
        ? Icon(Icons.cloud_done, color: Colors.white)
        : Icon(Icons.cloud_off, color: Colors.white30);
  }

  Widget _iconLocal() {
    return InkWell(
      onTap: null,
      // () {
      //   ShowAlertOptions.open(
      //     context: context,
      //     contentText:
      //         "Tem certeza que deseja ${isLocalEnabled ? 'desabilitar' : 'habilitar'} o mode operação local?",
      //     action: () {
      //       isLocalEnabled
      //           ? BlocProvider.of<LocalConfigBloc>(context)
      //               .add(ConfigEvent.disableLocal)
      //           : BlocProvider.of<LocalConfigBloc>(context)
      //               .add(ConfigEvent.enableLocal);

      //       //restart app
      //       BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
      //       Navigator.pushReplacement(context, SizeRoute(page: LoginScreen()));
      //     },
      //   );
      // },
      child: BlocBuilder<LocalConfigBloc, ConfigState>(
        builder: (BuildContext context, ConfigState state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: state.value
                ? Icon(Icons.wifi_tethering, color: Colors.white)
                : Icon(Icons.portable_wifi_off, color: Colors.white30),
          );
        },
      ),
    );
  }
}
