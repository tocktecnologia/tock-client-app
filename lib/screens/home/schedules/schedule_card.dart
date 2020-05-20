import 'package:flutter/material.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;

  const ScheduleCard({Key key, this.schedule}) : super(key: key);
  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: _content(),
    );
  }

  Widget _content() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: ColorsCustom.loginScreenMiddle.withAlpha(100),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ]),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          children: <Widget>[
            Text(
              widget.schedule.scheduleName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: ColorsCustom.loginScreenUp),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Divider(
                  color: ColorsCustom.loginScreenMiddle.withAlpha(100),
                  thickness: 1.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: SizedBox(width: 50)),
                Flexible(
                  child: Text(
                    widget.schedule.scheduleTime,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35, color: ColorsCustom.loginScreenMiddle),
                  ),
                ),
                Flexible(
                  child: Switch(
                    value: widget.schedule.scheduleState == 'ENABLED',
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Text(
              '${_getLabelsDaysWeek(widget.schedule.scheduleWeek)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _getLabelsDaysWeek(List days) {
    final weekString = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
    return days.map<String>((day) => weekString[day]).toList().join(' ');
  }
}
