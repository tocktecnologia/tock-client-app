import 'package:flutter/material.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';

const SIZE_WIDTH_LAMP = 70.0;

class TockDevice extends StatefulWidget {
  final device;

  const TockDevice({Key key, this.device}) : super(key: key);
  @override
  _TockDeviceState createState() => _TockDeviceState();
}

class _TockDeviceState extends State<TockDevice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('${widget.device.label}'),
      child: Container(
        width: SIZE_WIDTH_LAMP,
        child: Column(
          children: <Widget>[
            _getIcon(widget.device.type ?? DeviceTypes.LIGHT),
            SizedBox(height: 5),
            Text(
              widget.device.label,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIcon(type) {
    switch (type) {
      case DeviceTypes.LIGHT:
        return Icon(Icons.lightbulb_outline, size: 40, color: Colors.grey);
        break;
      case DeviceTypes.LIGHTS:
        return Icon(Icons.border_clear, size: 40, color: Colors.grey);
        break;
    }
  }
}
