import 'package:client/bloc/schedules/schedules_cubit.dart';
import 'package:client/screens/home/schedules/schedule_screen.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/components.dart';
import 'package:client/shared/utils/screen_transitions/size.transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule? schedule;

  const ScheduleCard({Key? key, this.schedule}) : super(key: key);
  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  Schedule? schedule;

  @override
  void initState() {
    super.initState();
    schedule = widget.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: _cardSchedule(),
    );
  }

  _cardSchedule() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, SizeRoute(page: ScheduleScreen(schedule: schedule!)));
      },
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: ColorsCustom.loginScreenMiddle.withAlpha(100),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]),
          // width: MediaQuery.of(context).size.width / 2.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Icon(
                        Icons.settings_backup_restore_sharp,
                        size: 30,
                      ),
                      onTap: () {
                        ShowAlert.open(
                          context: context,
                          contentText:
                              "Tem certeza que deseja REVERTER esse agendamento?",
                          confirmationText: "sim",
                          onConfirmation: () {
                            context
                                .read<SchedulesCubit>()
                                .executeScheduleActions(
                                    (schedule?.scheduleAction)!,
                                    reverse: true);

                            // BlocProvider.of<SchedulesCubit>(context).add(
                            //   ExecuteScheduleActionsEvent(
                            //     scheduleAction: schedule.scheduleAction,
                            //     reverse: true,
                            //   ),
                            // );
                          },
                        );
                      },
                    ),
                    Text(
                      (widget.schedule?.scheduleName)!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, color: ColorsCustom.loginScreenUp),
                    ),
                    const SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Divider(
                    color: ColorsCustom.loginScreenMiddle.withAlpha(100),
                    thickness: 1.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: SizedBox(
                            width: 70, height: 80, child: _deleteSchedule())),
                    Flexible(
                      child: Text(
                        (widget.schedule?.scheduleTime)!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 37,
                            color: ColorsCustom.loginScreenMiddle),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                          width: 65,
                          height: 80,
                          child: _executeActions() // _switchSchedule()
                          ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 5),
                  child: Text(
                    _getLabelsDaysWeek((widget.schedule?.scheduleWeek)!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _executeActions() {
    return Column(
      children: [
        InkWell(
          child: const Icon(
            Icons.play_circle_outline_rounded,
            size: 70,
            color: Colors.blue,
          ),
          onTap: () => ShowAlert.open(
            context: context,
            contentText: "Tem certeza que deseja EXECUTAR esse agendamento?",
            confirmationText: "sim",
            onConfirmation: () {
              // context
              //     .read<SchedulesCubit>()
              //     .executeScheduleActions((schedule?.scheduleAction)!);
              // BlocProvider.of<SchedulesBloc>(context).add(
              //   ExecuteScheduleActionsEvent(
              //       scheduleAction: schedule.scheduleAction),
              // );
            },
          ),
        ),
      ],
    );
  }

  // _switchSchedule() {
  //   var schdeuleId;
  //   return BlocBuilder<SchedulesBloc, SchedulesState>(
  //     condition: (prevState, state) {
  //       if (prevState is EnablingScheduleState &&
  //           state is UpdateSchedulesErrorState) {
  //         if (schdeuleId == schedule.scheduleId)
  //           ShowAlert.open(context: context, contentText: state.message);
  //       }
  //       return;
  //     },
  //     builder: (context, state) {
  //       if (state is EnablingScheduleState) {
  //         if (state.schedule.scheduleId == schedule.scheduleId) {
  //           schdeuleId = state.schedule.scheduleId;
  //           return SpinKitWave(color: ColorsCustom.loginScreenUp, size: 30);
  //         } else
  //           return _switchButton();
  //       } else {
  //         return _switchButton();
  //       }
  //     },
  //   );
  // }

  // _switchButton() {
  //   return Switch(
  //     value: widget.schedule.scheduleState == 'ENABLED',
  //     onChanged: (value) {
  //       final scheduleState = value ? 'ENABLED' : 'DISABLED';
  //       print(scheduleState);
  //       BlocProvider.of<SchedulesBloc>(context).add(
  //           EnableScheduleEvent(schedule: schedule, newState: scheduleState));
  //     },
  //   );
  // }

  _deleteSchedule() {
    var idSchdeule;
    return BlocBuilder<SchedulesCubit, SchedulesState>(
      buildWhen: (prevState, state) {
        if (prevState is DeletingScheduleState &&
            state is UpdateSchedulesErrorState) {
          if (idSchdeule == schedule?.scheduleId) {
            ShowAlert.open(context: context, contentText: state.message);
          }
        }
        return true;
      },
      builder: (context, state) {
        if (state is DeletingScheduleState) {
          if (state.schedule.scheduleId == schedule?.scheduleId) {
            idSchdeule = state.schedule.scheduleId;
            return const SpinKitThreeBounce(
                color: ColorsCustom.loginScreenUp, size: 20);
          } else {
            return _deleteScheduleButton();
          }
        } else {
          return _deleteScheduleButton();
        }
      },
    );
  }

  Widget _deleteScheduleButton() {
    return InkWell(
      splashColor: Colors.red,
      onTap: () => {},
      child: const Icon(
        Icons.restore_from_trash,
        size: 30,
        color: ColorsCustom.loginScreenUp,
      ),
    );
  }

  String _getLabelsDaysWeek(List<dynamic> days) {
    days.sort();
    final weekString = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
    String daysWeek = "";
    for (int i = 0; i < days.length; i++) {
      int idxWeek = days[i].round();
      daysWeek = '$daysWeek ${weekString[idxWeek]}';
    }
    return daysWeek;
  }
}
