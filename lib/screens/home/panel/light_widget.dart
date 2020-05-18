import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';

const SIZE_WIDTH_LAMP = 70.0;

class TockLight extends StatefulWidget {
  final Light light;

  const TockLight({Key key, this.light}) : super(key: key);
  @override
  _TockLightState createState() => _TockLightState();
}

class _TockLightState extends State<TockLight> {
  String mState;

  @override
  void initState() {
    super.initState();
    mState = widget.light.state;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(),
      child: Container(
        width: SIZE_WIDTH_LAMP,
        child: Column(
          children: <Widget>[
            _icon(),
            SizedBox(height: 5),
            Text(
              widget.light.device.label,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }

  _onTap() {
    if (BlocProvider.of<LightsBloc>(context).state is UpdatingLightState)
      return;
    BlocProvider.of<LightsBloc>(context)
        .add(TouchLightEvent(light: widget.light));
  }

  _icon() {
    return BlocBuilder<LightsBloc, LightsState>(
      builder: (context, state) {
        if (state is UpdatingLightState) {
          if (state.light.device.pin == widget.light.device.pin) {
            return Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: SIZE_WIDTH_LAMP * 0.45,
                height: SIZE_WIDTH_LAMP * 0.45,
                child: CircularProgressIndicator(
                  backgroundColor: ColorsCustom.loginScreenUp,
                ),
              ),
            );
          } else {
            return _getIcon(
                widget.light.device.type ?? DeviceTypes.LIGHT, mState);
          }
        } else if (state is UpdatedLightState) {
          if (state.light.device.pin == widget.light.device.pin) {
            mState = state.light.state;
          }
          return _getIcon(
              widget.light.device.type ?? DeviceTypes.LIGHT, mState);
        } else {
          return _getIcon(
              widget.light.device.type ?? DeviceTypes.LIGHT, mState);
        }
      },
    );
  }

  Widget _getIcon(type, mState) {
    switch (type) {
      case DeviceTypes.LIGHT:
        return Icon(Icons.lightbulb_outline,
            size: 40,
            color: mState == "1"
                ? Colors.yellow
                : mState == "0" ? Colors.grey : Colors.blue);
        break;
      case DeviceTypes.LIGHTS:
        return Icon(Icons.border_clear, size: 40, color: Colors.grey);
        break;
      default:
        return Icon(Icons.border_clear, size: 40, color: Colors.grey);
    }
  }
}
