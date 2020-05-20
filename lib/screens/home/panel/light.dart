import 'package:aws_iot/aws_iot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';

const SIZE_WIDTH_LAMP = 70.0;

class TockLight extends StatefulWidget {
  final Light light;
  final bool isConfigMode;

  const TockLight({Key key, this.light, this.isConfigMode}) : super(key: key);
  @override
  _TockLightState createState() => _TockLightState();
}

class _TockLightState extends State<TockLight> {
  final TextEditingController lightNameController = TextEditingController();
  Light light;
  bool forceHideAnimation = false;

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
          onDoubleTap: () =>
              widget.isConfigMode ? _showDialogHideAnimation() : {},
          onTap: () =>
              widget.isConfigMode ? _configLight() : _updateLightState(),
          splashColor: ColorsCustom.loginScreenMiddle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_icon(),
              _getIcon(light.device.type ?? DeviceTypes.LIGHT, light.state),
              _progress(),
              SizedBox(height: 5),
              Text(
                light.device.label,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12, color: Colors.black.withAlpha(200)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialogHideAnimation() {
    showDialog(
        context: context,
        child: Alert(
          contentText:
              "A animação do clique foi ${forceHideAnimation ? 'habilitada' : 'desabilitada'}.'",
        ));

    setState(() => forceHideAnimation = !forceHideAnimation);
  }

  Widget _progress() {
    if (light.state != '0' && light.state != '1' && !forceHideAnimation) {
      return SizedBox(
        width: SIZE_WIDTH_LAMP * 0.7,
        height: SIZE_WIDTH_LAMP * 0.06,
        child: LinearProgressIndicator(
          backgroundColor: ColorsCustom.loginScreenUp,
        ),
      );
    } else
      return SizedBox(
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

  _updateLightState() {
    if (light.state != "0" && light.state != "1") {
      return;
    }

    AWSIotDevice awsIotDevice = Locator.instance.get<AwsIot>().awsIotDevice;
    final state = light.state == "1" ? "0" : "1";

    // publish mqtt
    print('state:$state');
    awsIotDevice.publishJson({
      'state': {
        'desired': {'pin${light.device.pin}': int.parse(state)}
      }
    }, topic: '\$aws/things/${light.device.remoteId}/shadow/update');

    setState(() {
      light.state = "2";
    });
  }

  Widget _getIcon(type, mState) {
    switch (type) {
      case DeviceTypes.LIGHT:
        return Tab(
          icon: mState == "1"
              ? Image.asset("assets/icons/lampOn.png")
              : Image.asset("assets/icons/lampOff.png"),
        );
        break;
      case DeviceTypes.LIGHTS:
        return Tab(
          icon: mState == "1"
              ? Image.asset("assets/icons/lampsOn.png")
              : Image.asset("assets/icons/lampsOff.png"),
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
        content: TextFormField(
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
      ),
    );
  }
}
