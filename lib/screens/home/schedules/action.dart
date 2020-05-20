import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';

class ActionWidget extends StatefulWidget {
  final scheduleAction;

  const ActionWidget({Key key, this.scheduleAction}) : super(key: key);
  @override
  _ActionWidgetState createState() => _ActionWidgetState();
}

class _ActionWidgetState extends State<ActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: ColorsCustom.loginScreenUp,
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          widget.scheduleAction.action.label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: ColorsCustom.loginScreenUp),
        ),
      ),
    );
  }
}
