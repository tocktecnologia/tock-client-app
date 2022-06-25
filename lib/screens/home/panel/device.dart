import 'package:aws_iot/aws_iot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/light/light_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/local_network/local_network_bloc.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';

const SIZE_WIDTH_LAMP = 70.0;

class TockDevice extends StatefulWidget {
  final Light light;
  final bool isConfigMode;

  const TockDevice({Key key, this.light, this.isConfigMode}) : super(key: key);
  @override
  _TockDeviceState createState() => _TockDeviceState();
}

class _TockDeviceState extends State<TockDevice> {
  final TextEditingController lightNameController = TextEditingController();
  Light light;
  bool forceHideAnimation = false;
  bool showProgress = false;

  @override
  void initState() {
    super.initState();
    light = widget.light;
    lightNameController.text = light.device.label;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: SIZE_WIDTH_LAMP,
        child: InkWell(
          onTap: () => widget.isConfigMode ? _configLight() : _onActionDevice(),
          splashColor: ColorsCustom.loginScreenMiddle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _icon(),
              _progress(),
              SizedBox(height: 5),
              InkWell(
                onDoubleTap: () =>
                    widget.isConfigMode ? _showDialogHideAnimation() : {},
                child: Text(
                  light.device.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withAlpha(200)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialogHideAnimation() {
    // showDialog(
    //     context: context,
    //     child: Alert(
    //       contentText:
    //           "A animação do clique foi ${forceHideAnimation ? 'habilitada' : 'desabilitada'}.'",
    //     ));

    // setState(() => forceHideAnimation = !forceHideAnimation);
  }

  Widget _progress() {
    return showProgress
        ? SizedBox(
            width: SIZE_WIDTH_LAMP * 0.7,
            height: SIZE_WIDTH_LAMP * 0.06,
            child: LinearProgressIndicator(
              backgroundColor: ColorsCustom.loginScreenUp,
            ),
          )
        : SizedBox(
            width: SIZE_WIDTH_LAMP * 0.7,
            height: SIZE_WIDTH_LAMP * 0.06,
          );
  }

  _changeLightName() {
    List<Light> lights = BlocProvider.of<LightsBloc>(context).lights;
    lights.elementAt(lights.indexOf(light)).device.label =
        lightNameController.text;
    BlocProvider.of<LightsBloc>(context).setLights(lights);
    setState(() {});
  }

  _onActionDevice() {
    final type = light.device.type;
    if (type == DeviceTypes.BOMB || type == DeviceTypes.LIGHT) {
      _updateLightState();
    } else if (type == DeviceTypes.PULSE_ONOFF ||
        type == DeviceTypes.PULSE_COLOR) {
      _updateTockState();
    } else {
      // no actions for a while
    }
  }

  _updateTockState() async {
    setState(() {
      showProgress = true;
    });
    AWSIotDevice awsIotDevice = Locator.instance.get<AwsIot>().awsIotDevice;
    final msg = {
      'state': {
        'desired': {'pin${light.device.pin}': 'x'}
      }
    };
    awsIotDevice.publishJson(
      msg,
      topic: MqttTopics.tockUpdate,
    );
  }

  _updateLightState() async {
    setState(() {
      showProgress = true;
    });
    final state = light.state == '1' ? '0' : '1';
    BlocProvider.of<LocalConfigBloc>(context).state.value
        ? _publishCentral(state)
        : _publishMqtt(state, int.parse(light.device.pin));
  }

  _publishCentral(state) async {
    print('publishing local');
    final status = await Locator.instance
        .get<FirmwareApi>()
        .updateState(light: this.light, newState: state);
    if (status) {
      setState(() {
        light.state = state;
        showProgress = false;
      });
    } else {
      ShowAlert.open(
          context: context,
          contentText:
              "Você não está conectado na central!\n Verifique sua conexão coma rede local.");
      setState(() {
        showProgress = false;
      });
    }
  }

  _publishMqtt(state, pinNumber) {
    AWSIotDevice awsIotDevice = Locator.instance.get<AwsIot>().awsIotDevice;
    awsIotDevice.publishJson(
      {
        'state': {
          'desired': {'pin$pinNumber': int.parse(state)}
        }
      },
      topic: '\$aws/things/${light.device.remoteId}/shadow/update',
    );
  }

  Widget _icon() {
    return BlocListener<LightBloc, LightState>(
      listener: (context, state) {
        if (state is GettedLighState) {
          if (state.deviceId == light.device.remoteId &&
              state.pin == light.device.pin) {
            setState(() {
              light.state = state.state;
              showProgress = false;
            });
          }
        }
      },
      child: _getIcon(light.device.type ?? DeviceTypes.LIGHT, light.state),
    );
  }

  Widget _getIcon(type, mState) {
    switch (type) {
      case DeviceTypes.LIGHT:
        return Tab(
          icon: mState == LightStatesLogic.LIGHT_OFF
              ? Image.asset("assets/icons/lampOn.png")
              : Image.asset("assets/icons/lampOff.png"),
        );
        break;
      case DeviceTypes.BOMB:
        return SizedBox(
          width: 60,
          height: 60,
          child: Tab(
            icon: mState == LightStatesLogic.LIGHT_ON
                ? Image.asset("assets/icons/bombOn.png")
                : Image.asset("assets/icons/bombOff.png"),
          ),
        );
      case DeviceTypes.LIGHTS:
        return Tab(
          icon: mState == LightStatesLogic.LIGHT_ON
              ? Image.asset("assets/icons/lampsOn.png")
              : Image.asset("assets/icons/lampsOff.png"),
        );
        break;
      case DeviceTypes.PULSE_ONOFF:
        return Tab(
          icon: Image.asset("assets/icons/pulse-onoff.png"),
        );
        break;
      case DeviceTypes.PULSE_COLOR:
        return Tab(
          icon: Image.asset("assets/icons/pulse-color.png"),
        );
        break;

      default:
        return Icon(Icons.sentiment_dissatisfied, size: 40, color: Colors.grey);
    }
  }

  _configLight() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: <Widget>[
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                _changeLightName();
                Navigator.pop(context);
              },
              child: Text('OK'),
              color: ColorsCustom.loginScreenUp)
        ],
        title: Text('Alterar Nome',
            style: TextStyle(color: ColorsCustom.loginScreenUp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pin ${light.device.pin}',
              style: TextStyle(color: Colors.grey),
            ),
            TextFormField(
              controller: lightNameController,
              decoration: InputDecoration(
                  hintText: "Nome da luz",
                  contentPadding: EdgeInsets.all(5),
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlue))),
              onFieldSubmitted: (text) {
                _changeLightName();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
