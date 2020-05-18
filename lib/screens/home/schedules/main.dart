import 'package:flutter/material.dart';
import 'package:flutter_login_setup_cognito/screens/home/schedules/schedule_screen.dart';
import 'package:flutter_login_setup_cognito/shared/utils/screen_transitions/slide.transition.dart';

class SchedulesScreen extends StatefulWidget {
  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agendamentos"),
        centerTitle: true,
        actions: <Widget>[_addSchedule()],
      ),
      body: Center(
        child: Text("SchedulesScreen"),
      ),
    );
  }

  _addSchedule() {
    return InkWell(
        onTap: () =>
            Navigator.push(context, SlideLeftRoute(page: ScheduleScreen())),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.add_circle,
            size: 30,
          ),
        ));
  }
}
