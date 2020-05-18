import 'package:flutter/material.dart';
import 'package:flutter_login_setup_cognito/shared/model/schedule_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List _daysWeeks = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
  ScheduleRecurrent scheduleRecurrent;
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 00);

  @override
  void initState() {
    super.initState();
    scheduleRecurrent = ScheduleRecurrent();
    scheduleRecurrent.scheduleWeek = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[_save()],
          title: Text("Novo Agendamento"),
        centerTitle: true,
        backgroundColor: ColorsCustom.loginScreenUp,
      ),
      floatingActionButton: Icon(
        Icons.add_circle,
        color: ColorsCustom.loginScreenUp,
        size: 50,
      ),
      body: _content(),
    );
  }

  _save() {
    return InkWell(
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _content() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: ColorsCustom.loginScreenUp, thickness: 1),
        ),
        Container(
          child: InkWell(
            onTap: () => _selectTime(context),
            child: Text(
              "${_selectedTime.format(context)}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                color: ColorsCustom.loginScreenMiddle,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: ColorsCustom.loginScreenUp, thickness: 1),
        ),
        _panelDaysWeek(),
        Divider(),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    setState(() {
      _selectedTime = picked;
      scheduleRecurrent.scheduleTime = "${picked.hour}:${picked.minute}";
    });
  }

  Widget _panelDaysWeek() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: List.generate(
          7,
          (int index) => Flexible(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: RawMaterialButton(
                onPressed: () {
                  // if (scheduleRecurrent.scheduleWeek.indexOf(index) < 0) {
                  setState(() {
                    if (scheduleRecurrent.scheduleWeek.indexOf(index) < 0) {
                      scheduleRecurrent.scheduleWeek.add(index);
                    } else {
                      scheduleRecurrent.scheduleWeek.remove(index);
                    }
                  });
                  print(scheduleRecurrent.scheduleWeek);
                },
                elevation: 2.0,
                fillColor: scheduleRecurrent.scheduleWeek.indexOf(index) < 0
                    ? Colors.white
                    : Colors.blue,
                child: Text(
                  "${_daysWeeks[index]}",
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
