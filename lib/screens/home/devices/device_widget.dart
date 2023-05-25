import 'package:client/bloc/devices/devices_bloc.dart';
import 'package:client/screens/home/devices/device_state.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/components.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const sizeWidthLamp = 70.0;

class DeviceWidget extends StatefulWidget {
  final DeviceState deviceState;

  const DeviceWidget({Key? key, required this.deviceState}) : super(key: key);
  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  final TextEditingController lightNameController = TextEditingController();
  DeviceState? deviceState;
  bool forceHideAnimation = false;
  bool showProgress = false;
  DeviceState? myDevice;

  @override
  void initState() {
    super.initState();
    deviceState = widget.deviceState;
    lightNameController.text = deviceState?.label ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: sizeWidthLamp,
        child: InkWellSplash(
          splashFactory: InkRipple.splashFactory,
          doubleTapTime: const Duration(milliseconds: 155),
          onDoubleTap: () => _configLight(),
          onTap: () => _onActionDevice(),
          splashColor: ColorsCustom.loginScreenMiddle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _icon(),
              _progress(),
              const SizedBox(height: 5),
              Text(
                lightNameController.text,
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

  Widget _progress() {
    return showProgress
        ? const SizedBox(
            width: sizeWidthLamp * 0.7,
            height: sizeWidthLamp * 0.06,
            child: LinearProgressIndicator(
              backgroundColor: ColorsCustom.loginScreenUp,
            ),
          )
        : const SizedBox(
            width: sizeWidthLamp * 0.7, height: sizeWidthLamp * 0.06);
  }

  _onActionDevice() {
    setState(() {
      showProgress = true;
    });

    final String state = deviceState?.state == DeviceStateLogic.DEVICE_ON
        ? DeviceStateLogic.DEVICE_OFF
        : DeviceStateLogic.DEVICE_ON;

    final Map<String, dynamic> msg = {
      'state': {
        'desired': {'pin${deviceState?.pin}': state}
      }
    };
    final String topic = '\$aws/things/${deviceState?.remoteId}/shadow/update';

    Locator.instance.get<MqttService>().publishJson(msg, topic);
  }

  Widget _icon() {
    return BlocBuilder<DevicesCubit, DevicesState>(
      buildWhen: (previous, current) {
        if (current is UpdatedDevicesState) {
          final deviceStateList = current.deviceStateList
              .where((element) => element.pin == widget.deviceState.pin);

          if (deviceStateList.isNotEmpty) {
            setState(() {
              showProgress = false;
              deviceState?.state = deviceStateList.first.state;
            });
          }
        }
        return true;
      },
      builder: (context, state) {
        if (state is UpdatedDevicesState) {
          final myDeviceState = state.deviceStateList
              .where((element) => element.pin == widget.deviceState.pin)
              .first
              .state;
          return _getIcon(widget.deviceState.type, myDeviceState);
        } else {
          return _getIcon(
              deviceState?.type ?? DeviceTypes.LIGHT, deviceState?.state);
        }
      },
    );
  }

  Widget _getIcon(type, mState) {
    switch (type) {
      case DeviceTypes.LIGHT:
        return Tab(
          icon: mState == DeviceStateLogic.DEVICE_ON
              ? Image.asset("assets/icons/lampOff.png")
              : Image.asset("assets/icons/lampOn.png"),
        );
      case DeviceTypes.BOMB:
        return SizedBox(
          width: 60,
          height: 60,
          child: Tab(
            icon: mState == DeviceStateLogic.DEVICE_OFF
                ? Image.asset("assets/icons/bombOff.png")
                : Image.asset("assets/icons/bombOn.png"),
          ),
        );
      case DeviceTypes.LIGHTS:
        return Tab(
          icon: mState == DeviceStateLogic.DEVICE_ON
              ? Image.asset("assets/icons/lampsOff.png")
              : Image.asset("assets/icons/lampsOn.png"),
        );
      case DeviceTypes.PULSE_ONOFF:
        return Tab(
          icon: Image.asset("assets/icons/pulse-onoff.png"),
        );
      case DeviceTypes.PULSE_COLOR:
        return Tab(
          icon: Image.asset("assets/icons/pulse-color.png"),
        );
      default:
        return const Icon(Icons.sentiment_dissatisfied,
            size: 40, color: Colors.grey);
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
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
        title: const Text('Alterar Nome',
            style: TextStyle(color: ColorsCustom.loginScreenUp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pin ${deviceState?.pin}',
              style: const TextStyle(color: Colors.grey),
            ),
            TextFormField(
              controller: lightNameController,
              decoration: const InputDecoration(
                  hintText: "Nome da luz",
                  contentPadding: EdgeInsets.all(5),
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlue))),
              onFieldSubmitted: (text) {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
