import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/schedules/schedules_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/schedules/schedule_card.dart';
import 'package:flutter_login_setup_cognito/screens/home/schedules/schedule_screen.dart';
import 'package:flutter_login_setup_cognito/shared/utils/screen_transitions/slide.transition.dart';
import 'package:reorderables/reorderables.dart';

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
      body: _content(),
    );
  }

  Widget _content() {
    return BlocBuilder<SchedulesBloc, SchedulesState>(
      builder: (context, state) {
        if (state is UpdatingSchedulesState)
          return Container();
        else if (state is UpdatedSchedulesState) {
          print(state.schedules);
          return _listWrapReorderable(state.schedules);
        } else
          return Container();
      },
    );
  }

  Widget _listWrapReorderable(schdeules) {
    final schdeulesList = schdeules
        .map<ScheduleCard>((schdeule) => ScheduleCard(schedule: schdeule))
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ReorderableWrap(
        direction: Axis.horizontal,
        runSpacing: 20,
        padding: EdgeInsets.symmetric(vertical: 20),
        children: schdeulesList,
        onReorder: _onReorder,
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    // BlocProvider.of<LightsBloc>(context)
    //     .add(UpdateIdxLightsEvent(oldIndex: oldIndex, newIndex: newIndex));
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
