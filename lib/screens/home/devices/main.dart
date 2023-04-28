import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/devices/devices_bloc.dart';
import 'package:client/bloc/mqtt_connect/mqtt_connect_bloc.dart';
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

const paddingHorizIntern = 10.0;
const paddingHorizExtern = 10.0;
const numLampsRow = kIsWeb ? 7 : 4;

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen>
    with WidgetsBindingObserver {
  AppLifecycleState? _notification;
  bool isLocalEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });

    // if (state == AppLifecycleState.resumed) {
    //   final bool isConnected =
    //       Locator.instance.get<MqttService>().isConnected();
    //   if (!isConnected) {
    //     context.read<MqttConnectCubit>().mqttConnect();
    //   }
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _listenMqtt() {
    final client = Locator.instance.get<MqttService>().awsClient?.client;
    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      context.read<DevicesCubit>().updateReportedDevices(pt);
    });
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
          actions: [_iconLocal()],
          leading: _iconRemote(),
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
    return BlocBuilder<DataUserCubit, DataUserState>(
      builder: (context, state) {
        if (state is LoadedDataUserState) {
          context.read<DevicesCubit>().initListDevices(state.dataUser.devices!);
          return _listWrapReorderable(state.dataUser.devices!);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _updateButton() {
    return BlocBuilder<MqttConnectCubit, MqttConnectState>(
        builder: (context, state) {
      if (state is ConnectingMqttState) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child:
              SpinKitThreeBounce(color: ColorsCustom.loginScreenUp, size: 20),
        );
      } else {
        return _icon();
      }
    });
  }

  Widget _icon() {
    return InkWell(
      onTap: () => _updateStates(),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Icon(Icons.update, size: 27, color: ColorsCustom.loginScreenUp),
      ),
    );
    // return BlocBuilder<LightsBloc, LightsState>(builder: (context, state) {
    //   if (state is UpdatingDevicesState) {
    //     return Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    //       child:
    //           SpinKitThreeBounce(color: ColorsCustom.loginScreenUp, size: 20),
    //     );
    //   } else
    //     return InkWell(
    //       onTap: () => _updateStates(),
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    //         child:
    //             Icon(Icons.update, size: 27, color: ColorsCustom.loginScreenUp),
    //       ),
    //     );
    // });
  }

  _updateStates() async {
    context.read<MqttConnectCubit>().mqttDisconnect();
    context.read<DataUserCubit>().getDataUser(forceCloud: true);
  }

  Widget _listWrapReorderable(List<Device> deviceList) {
    // final lights = BlocProvider.of<LightsBloc>(context).lights;

    final devicesWidget = deviceList
        .map<DeviceWidget>(
          (device) => DeviceWidget(
            deviceState: DeviceState(device: device),
          ),
        )
        .toList();

    return ReorderableWrap(
      spacing: (MediaQuery.of(context).size.width -
              numLampsRow * sizeWidthLamp -
              2 * paddingHorizExtern -
              2 * paddingHorizIntern) /
          (numLampsRow - 1),
      runSpacing: 20,
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      onReorder: _onReorder,
      enableReorder: false,
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

  Widget _iconRemote() {
    return const Icon(Icons.cloud_off, color: Colors.white30);
    // return BlocProvider.of<AuthBloc>(context).isConnectedRemote
    //     ? const Icon(Icons.cloud_done, color: Colors.white)
    //     : const Icon(Icons.cloud_off, color: Colors.white30);
  }

  Widget _iconLocal() {
    return const DropdownButtonExample();
    // return BlocBuilder<DataUserCubit, DataUserState>(
    //   builder: (context, state)  {
    //     if (state is LoadedDataUserState) {
    //       return InkWell(
    //         onTap: () {
    //           // BlocProvider.of<MqttCubit>(context).setHost(MqttSecrets.localhost);
    //           // context
    //           //     .read<MqttConnectCubit>()
    //           //     .changeHost(MqttSecrets.localHost,state);
    //         },
    //         child: const Padding(
    //           padding: EdgeInsets.only(right: 10),
    //           // child: Icon(Icons.wifi_tethering, color: Colors.white),
    //           child: DropdownButtonExample(),
    //         ),
    //       );
    //     }
    //      else return
    //   },
    // );

    return InkWell(
      onTap: () {
        // BlocProvider.of<MqttCubit>(context).setHost(MqttSecrets.localhost);
        // context.read<MqttConnectCubit>().changeHost(MqttSecrets.localHost);
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 10),
        // child: Icon(Icons.wifi_tethering, color: Colors.white),
        child: DropdownButtonExample(),
      ),
    );
    // return InkWell(
    // onTap: null,
    // () {
    //   ShowAlertOptions.open(
    //     context: context,
    //     contentText:
    //         "Tem certeza que deseja ${isLocalEnabled ? 'desabilitar' : 'habilitar'} o mode operação local?",
    //     action: () {
    //       isLocalEnabled
    //           ? BlocProvider.of<LocalConfigBloc>(context)
    //               .add(ConfigEvent.disableLocal)
    //           : BlocProvider.of<LocalConfigBloc>(context)
    //               .add(ConfigEvent.enableLocal);

    //       //restart app
    //       BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
    //       Navigator.pushReplacement(context, SizeRoute(page: LoginScreen()));
    //     },
    //   );
    // },
    //   child: BlocBuilder<LocalConfigBloc, ConfigState>(
    //     builder: (BuildContext context, ConfigState state) {
    //       return Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 10),
    //         child: state.value
    //             ? Icon(Icons.wifi_tethering, color: Colors.white)
    //             : Icon(Icons.portable_wifi_off, color: Colors.white30),
    //       );
    //     },
    //   ),
    // );
  }
}
