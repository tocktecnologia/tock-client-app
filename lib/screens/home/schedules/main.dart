import 'package:client/bloc/schedules/schedules_cubit.dart';
import 'package:client/screens/home/schedules/schedule_card.dart';
import 'package:client/screens/home/schedules/schedule_screen.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/screen_transitions/slide.transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reorderables/reorderables.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  List<Schedule>? _schedules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamentos"),
        centerTitle: true,
        actions: <Widget>[_addSchedule()],
      ),
      body: _content(),
    );
  }

  Widget _content() {
    return BlocBuilder<SchedulesCubit, SchedulesState>(
        builder: (context, state) {
      if (state is UpdatingSchedulesState) {
        return const Center(
          child: SpinKitThreeBounce(
            color: ColorsCustom.loginScreenMiddle,
          ),
        );
      } else if (state is UpdatedSchedulesState) {
        _schedules = state.schedules;
        return _listWrapReorderable(_schedules);
      } else {
        return Text("state: $state");
      }
    });
  }

  Widget _listWrapReorderable(schdeules) {
    final schdeulesList = schdeules
        .map<ScheduleCard>((schdeule) => ScheduleCard(schedule: schdeule))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ReorderableWrap(
        direction: Axis.horizontal,
        spacing: 50,
        runSpacing: 20,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: schdeulesList,
        alignment: WrapAlignment.spaceEvenly,
        onReorder: _onReorder,
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    // final w = _schedules.removeAt(oldIndex);
    // _schedules.insert(newIndex, w);
    // BlocProvider.of<SchedulesBloc>(context)
    //     .add(UpdateSchedulesConfigsEvent(schedules: _schedules));
  }

  _addSchedule() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            SlideLeftRoute(
              page: ScheduleScreen(
                schedule: Schedule(),
              ),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.add_circle,
            size: 30,
          ),
        ));
  }
}
