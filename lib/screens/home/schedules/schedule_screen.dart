import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/schedules/schedules_bloc.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
import 'package:flutter_login_setup_cognito/shared/utils/constants.dart';
import 'package:flutter_login_setup_cognito/shared/utils/conversions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

const SIZE_WIDTH_LAMP = 80.0;
const NUM_LAMPS_ROW = 3;
const PADDING_HORIZ_INTERN = 15.0;

class ScheduleScreen extends StatefulWidget {
  final Schedule schedule;
  const ScheduleScreen({Key key, this.schedule}) : super(key: key);
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List _daysWeeks = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
  TextEditingController sheduleNameController = TextEditingController();

  Schedule scheduleRecurrent;
  List<ScheduleAction> scheduleAction = List<ScheduleAction>();
  var uuid;

  @override
  void initState() {
    super.initState();
    uuid = new Uuid();

    // se nao null, valores iniciais
    scheduleRecurrent = widget.schedule ?? Schedule();
    scheduleRecurrent.scheduleAction = widget.schedule?.scheduleAction ??
        List<ScheduleAction>(); //List<ScheduleAction>();
    scheduleRecurrent.scheduleWeek =
        widget.schedule?.scheduleWeek ?? [0, 1, 2, 3, 4, 5, 6];
    scheduleRecurrent.scheduleId = widget.schedule?.scheduleId ?? uuid.v4();
    scheduleRecurrent.scheduleName = widget.schedule?.scheduleName ?? '';
    scheduleRecurrent.scheduleTime = widget.schedule?.scheduleTime ?? '00:00';
    scheduleRecurrent.scheduleType = "RECURRENT";
    scheduleRecurrent.scheduleState =
        widget.schedule?.scheduleState ?? "ENABLED";

    // initialize title
    sheduleNameController.text = scheduleRecurrent.scheduleName;

    // final time = scheduleRecurrent.scheduleTime.split(":");
    // // _selectedTime =
    // //     TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  @override
  void dispose() {
    super.dispose();
    sheduleNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[_saveButon()],
        title: TextFormField(
          decoration: InputDecoration(
            hintText: 'Título',
            hintStyle: TextStyle(color: Colors.grey.shade300),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
          controller: sheduleNameController,
          onSaved: (text) {
            scheduleRecurrent.scheduleName = text;
          },
        ),
        centerTitle: true,
        backgroundColor: ColorsCustom.loginScreenMiddle,
      ),
      floatingActionButton: InkWell(
        onTap: () => _showModalDevices(),
        child: Icon(
          Icons.add_circle,
          color: ColorsCustom.loginScreenMiddle,
          size: 50,
        ),
      ),
      body: _content(),
    );
  }

  Widget _content() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Divider(color: ColorsCustom.loginScreenMiddle, thickness: 1),
        ),
        Container(
          child: InkWell(
            onTap: () => _selectTime(context),
            child: Text(
              '${(scheduleRecurrent.scheduleTime)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                color: ColorsCustom.loginScreenUp,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: ColorsCustom.loginScreenMiddle, thickness: 1),
        ),
        _panelDaysWeek(),
        Divider(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            separatorBuilder: (context, i) => SizedBox(height: 20),
            itemCount: scheduleRecurrent.scheduleAction?.length,
            itemBuilder: (context, index) {
              return _actionCard(scheduleRecurrent.scheduleAction[index]);
            },
          ),
        )
      ],
    );
  }

  Widget _actionCard(ScheduleAction scheduleAction) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorsCustom.loginScreenMiddle,
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () => _updateEventAction(scheduleAction),
              child: Tab(
                  child: _getIconAction(
                      scheduleAction.action.type, scheduleAction.action.event)),
            ),
            Text(
              scheduleAction.action.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: ColorsCustom.loginScreenUp),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: InkWell(
                onTap: () => _deletEventAction(scheduleAction),
                child: Icon(Icons.restore_from_trash,
                    color: ColorsCustom.loginScreenUp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconAction(type, state) {
    if (type == "LIGHT") {
      return state == LightStatesLogic.LIGHT_OFF
          ? Image.asset("assets/icons/lampOn.png")
          : Image.asset("assets/icons/lampOff.png");
    } else if (type == DeviceTypes.BOMB) {
      return state == LightStatesLogic.LIGHT_ON
          ? Image.asset("assets/icons/bombOn.png")
          : Image.asset("assets/icons/bombOff.png");
    } else {
      return state == LightStatesLogic.LIGHT_ON
          ? Image.asset("assets/icons/bombOn.png")
          : Image.asset("assets/icons/bombOff.png");
    }
  }

  _deletEventAction(ScheduleAction mScheduleAction) {
    final index = scheduleRecurrent.scheduleAction.indexWhere((sheduleAction) =>
        sheduleAction.action.actionId == mScheduleAction.action.actionId);
    setState(() {
      scheduleRecurrent.scheduleAction.removeAt(index);
    });
  }

  _updateEventAction(ScheduleAction mScheduleAction) {
    final newEvent = mScheduleAction.action.event == LightStatesLogic.LIGHT_ON
        ? LightStatesLogic.LIGHT_OFF
        : LightStatesLogic.LIGHT_ON;
    setState(() {
      scheduleRecurrent.scheduleAction
          .singleWhere((sheduleAction) =>
              sheduleAction.action.actionId == mScheduleAction.action.actionId)
          .action
          .event = newEvent;
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
                  setState(
                    () {
                      if (scheduleRecurrent.scheduleWeek.indexOf(index) < 0) {
                        scheduleRecurrent.scheduleWeek.add(index);
                      } else {
                        scheduleRecurrent.scheduleWeek.remove(index);
                      }
                    },
                  );
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

  _showModalDevices() {
    final lights = BlocProvider.of<LightsBloc>(context).lights;
    final lightsFromList =
        lights.map<Widget>((light) => _deviceModal(light)).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
          title: Text('Devices',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorsCustom.loginScreenMiddle, fontSize: 24)),
          subtitle: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: (MediaQuery.of(context).size.width -
                        3 * SIZE_WIDTH_LAMP -
                        2 * PADDING_HORIZ_INTERN) /
                    (NUM_LAMPS_ROW - 1),
                runSpacing: 20,
                children: lightsFromList,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _deviceModal(Light light) {
    return InkWell(
      // event bloc
      onTap: () => _addActionLight(light),
      child: Container(
        width: SIZE_WIDTH_LAMP,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tab(
              child: _getIconAction(light.device.type, light.state),
            ),
            SizedBox(height: 7),
            Text(
              light.device.label,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }

  _addActionLight(Light light) {
    setState(
      () => scheduleRecurrent.scheduleAction.insert(
        0,
        ScheduleAction(
          type: 'ACTION',
          action: TockAction(
              actionId: uuid.v4(),
              delay: "0",
              deviceId: light.device.remoteId,
              label: light.device.label,
              type: light.device.type,
              section: light.device.pin,
              event: light.state,
              objectId: light.device.localId),
        ),
      ),
    );
  }

  Widget _saveButon() {
    return BlocBuilder<SchedulesBloc, SchedulesState>(
        condition: (prevState, state) {
      if (state is UpdatedSchedulesState) {
        Navigator.pop(context);
      } else if (state is UpdateSchedulesErrorState) {
        ShowAlert.open(context: context, contentText: state.message);
      }
      return;
    }, builder: (context, state) {
      print(state);
      if (state is UpdatingSchedulesState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SpinKitThreeBounce(color: Colors.white, size: 20),
        );
      } else {
        return InkWell(
          onTap: () => _saveShedule(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.save),
          ),
        );
      }
    });
  }

  _saveShedule() {
    scheduleRecurrent.scheduleName =
        sheduleNameController.text == '' ? 'Nome' : sheduleNameController.text;
    BlocProvider.of<SchedulesBloc>(context).add(
      UpdateScheduleInListEvent(schedule: scheduleRecurrent),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final initalTime = scheduleRecurrent.scheduleTime.split(':');
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(initalTime[0]), minute: int.parse(initalTime[1])),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final hour = TockTime.formatTime(picked.hour.toString());
        final min = TockTime.formatTime(picked.minute.toString());
        scheduleRecurrent.scheduleTime = '$hour:$min';
      });
    }
  }
}
