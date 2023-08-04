import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/devices/devices_bloc.dart';
import 'package:client/bloc/mqtt_connect/mqtt_connect_bloc.dart';
import 'package:client/bloc/schedules/schedules_cubit.dart';
import 'package:client/screens/home/devices/device_widget.dart';
import 'package:client/screens/home/devices/device_state.dart';
import 'package:client/screens/home/devices/drop_down_hosts.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tuple/tuple.dart';

const paddingHorizIntern = 10.0;
const paddingHorizExtern = 10.0;

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen>
    with WidgetsBindingObserver {
  bool isLocalEnabled = false;
  List<String> thingIdList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeMetrics() {
  //   super.didChangeMetrics();
  //   // context.read<DevicesCubit>().getDevicesStates();
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _listenMqtt() {
    final client = Locator.instance.get<MqttService>().awsClient?.client;

    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (MqttReceivedMessage<MqttMessage> message in c) {
        final MqttPublishMessage recMess =
            message.payload as MqttPublishMessage;
        final String pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        // print("msg form ${message.topic}: $pt");

        context.read<DevicesCubit>().updateReportedDevices(pt, message.topic);
      }
    });

    // client?.updates?.listen((List<MqttReceivedMessage<MqttMessage?>> c) {
    //   final bytesPayload = c[0].payload as MqttPublishMessage;
    //   final message = MqttPublishPayload.bytesToStringAsString(
    //       bytesPayload.payload.message);

    //   // final bytesTopic = c[0].topic as MqttPublishMessage;
    //   // final topic =
    //   //     MqttPublishPayload.bytesToStringAsString(bytesTopic.payload.message);

    //   print("message arrived from : $message");

    //   context.read<DevicesCubit>().updateReportedDevices(message);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MqttConnectCubit, MqttConnectState>(
      listener: (context, state) {
        if (state is ConnectedMqttState) {
          _listenMqtt();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Olá!"),
          actions: const [DropdownButtonExample()],
          // leading: _iconRemote(),
          centerTitle: true,
        ),
        body: _cardLights(),
      ),
    );
  }

  Widget _cardLights() {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: paddingHorizExtern, vertical: 20),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: ColorsCustom.loginScreenMiddle,
                  blurRadius: 4,
                  spreadRadius: 0.5),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Container(),
                  ),
                  const Text(
                    "Dispositivos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorsCustom.loginScreenMiddle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  _updateButton()
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 0),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizIntern),
                child: _panelLights(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelLights() {
    // Bloc for user data
    return BlocBuilder<DataUserCubit, DataUserState>(
      builder: (context, state) {
        if (state is LoadedDataUserState) {
          final dataUser = state.dataUser;
          context.read<DevicesCubit>().initListDevices(dataUser.devices!);
          context.read<SchedulesCubit>().initListSchedules(dataUser.schedules!);

          // bloc for mqtt connection
          return BlocBuilder<MqttConnectCubit, MqttConnectState>(
            builder: (context, state) {
              if (state is ConnectingMqttState) {
                return _loading("Connectando  ... ");
              } else if (state is ConnectionErrorMqttState) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Falha na conexão, tente reiniciar!",
                    style: TextStyle(
                        fontSize: 17, color: ColorsCustom.loginScreenUp),
                  ),
                );
              } else if (state is ConnectedMqttState) {
                thingIdList = state.thingIdList;

                // bloc to get devices states
                return BlocBuilder<DevicesCubit, DevicesState>(
                  builder: (context, state) {
                    if (state is GettingDevicesState) {
                      return _loading("Recuperando estados  ... ");
                    } else if (state is UpdatedDevicesState) {
                      return _listWrapReorderable(state.deviceStateList);
                    } else {
                      return Text("state: $state");
                    }
                  },
                );
              } else {
                return Text("state: $state");
              }
            },
          );
        } else {
          return const Text("Nehum dado foi encontrado!");
        }
      },
    );
  }

  Widget _loading(msg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Center(
          child: SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
        ),
        const SizedBox(height: 20),
        Text(
          msg,
          style: const TextStyle(
            fontSize: 17,
            color: ColorsCustom.loginScreenUp,
          ),
        ),
      ],
    );
  }

  Widget _updateButton() {
    return BlocBuilder<MqttConnectCubit, MqttConnectState>(
        buildWhen: (previous, current) {
      if (previous is ConnectingMqttState && current is ConnectedMqttState) {
        context.read<DevicesCubit>().getDevicesStates();
      }
      return true;
    }, builder: (context, state) {
      if (state is ConnectingMqttState) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child:
              SpinKitThreeBounce(color: ColorsCustom.loginScreenUp, size: 20),
        );
      } else {
        return InkWell(
          onTap: () => _updateStates(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child:
                Icon(Icons.update, size: 27, color: ColorsCustom.loginScreenUp),
          ),
        );
      }
    });
  }

  _updateStates() {
    context.read<DevicesCubit>().getDevicesStates();
  }

  Widget _listWrapReorderable(List<DeviceState> deviceList) {
    final devicesWidget = deviceList
        .map<DeviceWidget>(
          (device) => DeviceWidget(
            deviceState: device,
          ),
        )
        .toList();

    return ReorderableWrap(
      spacing: kIsWeb ? 70 : 20,
      runSpacing: 20,
      padding: const EdgeInsets.symmetric(vertical: 20),
      onReorder: _onReorder,
      enableReorder: false,
      alignment: WrapAlignment.spaceEvenly,
      children: devicesWidget,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    // // get lights
    // final lights = BlocProvider.of<LightsBloc>(context).lights;

    // // change index
    // final w = lights.removeAt(oldIndex);
    // lights.insert(newIndex, w);

    // // update  lights in bloc
    // BlocProvider.of<LightsBloc>(context).setLights(lights);

    // //update view
    // setState(() {});
  }
}
