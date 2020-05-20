import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/schedules/action.dart';
import 'package:flutter_login_setup_cognito/shared/model/light_model.dart';
import 'package:flutter_login_setup_cognito/shared/model/schedule_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

const SIZE_WIDTH_LAMP = 80.0;
const NUM_LAMPS_ROW = 3;
const PADDING_HORIZ_INTERN = 15.0;

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List _daysWeeks = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
  ScheduleRecurrent scheduleRecurrent;
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 00);
  List<ScheduleAction> scheduleAction = List<ScheduleAction>();
  var uuid = new Uuid();

  @override
  void initState() {
    super.initState();
    scheduleRecurrent = ScheduleRecurrent();
    scheduleRecurrent.scheduleAction = List<ScheduleAction>();
    scheduleRecurrent.scheduleWeek = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[_saveButon()],
        title: Text("Novo Agendamento"),
        centerTitle: true,
        backgroundColor: ColorsCustom.loginScreenUp,
      ),
      floatingActionButton: InkWell(
        onTap: () => _addDevice(),
        child: Icon(
          Icons.add_circle,
          color: ColorsCustom.loginScreenUp,
          size: 50,
        ),
      ),
      body: _content(),
    );
  }

  void _addDevice() {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<LightsBloc, LightsState>(
        builder: (context, state) {
          if (state is LoadingLightStates) {
            return SizedBox(
              child: SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
            );
          } else if (state is LoadedLightStates) {
            final lights =
                state.lights.map<Widget>((light) => _device(light)).toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
                title: Text('Devices',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorsCustom.loginScreenMiddle, fontSize: 24)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: (MediaQuery.of(context).size.width -
                              3 * SIZE_WIDTH_LAMP -
                              2 * PADDING_HORIZ_INTERN) /
                          (NUM_LAMPS_ROW - 1),
                      runSpacing: 20,
                      children: lights,
                    ),
                  ),
                ),
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }

  Widget _device(Light light) {
    return InkWell(
      // event bloc
      onTap: () => _addActionLight(light),
      child: Container(
        width: SIZE_WIDTH_LAMP,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.lightbulb_outline),
            SizedBox(height: 8),
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
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            separatorBuilder: (context, i) => SizedBox(height: 20),
            itemCount: scheduleRecurrent.scheduleAction?.length,
            itemBuilder: (context, index) {
              return ActionWidget(
                  scheduleAction: scheduleRecurrent.scheduleAction[index]);
            },
          ),
        )
      ],
    );
  }

  Widget _saveButon() {
    return InkWell(
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.save),
      ),
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
                  setState(() {
                    if (scheduleRecurrent.scheduleWeek.indexOf(index) < 0) {
                      scheduleRecurrent.scheduleWeek.add(index);
                    } else {
                      scheduleRecurrent.scheduleWeek.remove(index);
                    }
                  });
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
