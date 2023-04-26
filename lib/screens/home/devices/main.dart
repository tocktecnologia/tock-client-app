import 'dart:async';

import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/mqtt/mqtt_connect_bloc.dart';
import 'package:client/screens/home/devices/device_state.dart';
import 'package:client/screens/home/devices/device_widget.dart';
import 'package:client/screens/home/devices/drop_down_hosts.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:client/shared/utils/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool isConfigMode = false;
  bool isLocalEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Locator.instance
    //     .get<MqttService>()
    //     .awsClient
    //     ?.messages
    //     .listen((mqttEvent) => {print("event: $mqttEvent")});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      print("state: $state");
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

  _onMessage(event) {
    print("event: $event");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MqttConnectCubit, MqttConnectState>(
      listener: (context, state) {
        print("state: $state");
        if (state is ConnectedMqttState) {
          print("ConnectedMqttState listening ...");
          Locator.instance
              .get<MqttService>()
              .awsClient
              ?.client
              ?.updates
              ?.listen((event) {
            _onMessage(event);
          });
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
            color: Colors.white, //isConfigMode ? Colors.grey. : Colors.white,
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
                  InkWell(
                    onTap: () => setState(() => isConfigMode = !isConfigMode),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Icon(
                        isConfigMode ? Icons.keyboard_return : Icons.mode_edit,
                        size: 20,
                        color: ColorsCustom.loginScreenUp,
                      ),
                    ),
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
      buildWhen: (previous, current) {
        print("current: $current");
        if (current is LoadDataUserErrorState) {
          showAboutDialog(context: context, children: <Widget>[
            Text(current.message!),
          ]);
        }
        if (previous is LoadingDataUserState &&
            current is LoadedDataUserState) {
          print("calling mqttConnect ...");

          context
              .read<MqttConnectCubit>()
              .mqttConnect(current.dataUser.devices!);
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingDataUserState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Center(
                  child: SpinKitRipple(
                      size: 30, color: ColorsCustom.loginScreenUp)),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Recuperando dados  ... ",
                    style: TextStyle(
                        fontSize: 17, color: ColorsCustom.loginScreenUp)),
              ),
            ],
          );
        } else if (state is LoadedDataUserState) {
          return _listWrapReorderable(state.dataUser.devices!);
        } else {
          return Container();
        }
      },
    );
  }

  // Widget centralConnectionDevices(UpdatedDevicesState stateLights) {
  //   BlocProvider.of<CentralBloc>(context)
  //       .add(GetUpdateLightsFromCentralEvent(lights: stateLights.lights));

  //   return BlocBuilder<CentralBloc, CentralState>(
  //     buildWhen: (prevState, state) {
  //       if (state is UpdateLightsFromCentralErrorState) {
  //         ShowAlert.open(context: context, contentText: state.message);
  //       }
  //       return true;
  //     },
  //     builder: (context, state) {
  //       if (state is UpdatingLightsFromCentralState) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: <Widget>[
  //             Center(
  //               child:
  //                   SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 20),
  //               child: Text("Atualizando estados da central... ",
  //                   style: TextStyle(
  //                       fontSize: 17, color: ColorsCustom.loginScreenUp)),
  //             ),
  //           ],
  //         );
  //       } else {
  //         return _listWrapReorderable(stateLights);
  //       }
  //     },
  //   );
  // }

  // Widget iotConnectionDevices(stateLights) {
  //   return BlocBuilder<IotAwsBloc, IotAwsState>(buildWhen: (prevState, state) {
  //     if (state is ConnectedIotAwsState) {
  //       // init listenning aws iot if not local choiced
  //       final AWSIotDevice awsIotDevice =
  //           Locator.instance.get<AwsIot>().awsIotDevice;
  //       // awsIotDevice.client.updates.listen(
  //       //   (_) {
  //       //     _onReceive(awsIotDevice);
  //       //   },
  //       // );
  //       _updateStates();
  //     }
  //     return true;
  //   }, builder: (context, state) {
  //     if (state is ConnectingIotAwsState) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Center(
  //             child: SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 20),
  //             child: Text("Conectando ao sistema ... ",
  //                 style: TextStyle(
  //                     fontSize: 17, color: ColorsCustom.loginScreenUp)),
  //           ),
  //         ],
  //       );
  //     } else if (state is ConnectedIotAwsState ||
  //         state is UpdatingLightsFromShadowState) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Center(
  //             child: SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 20),
  //             child: Text("Atualizando estados da nuvem... ",
  //                 style: TextStyle(
  //                     fontSize: 17, color: ColorsCustom.loginScreenUp)),
  //           ),
  //         ],
  //       );
  //     } else {
  //       return _listWrapReorderable(stateLights);
  //     }
  //   });
  // }

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

  Widget _listWrapReorderable(List<Device> devices) {
    // final lights = BlocProvider.of<LightsBloc>(context).lights;

    final devicesWidget = devices
        .map<DeviceWidget>(
          (device) => DeviceWidget(
            deviceState: DeviceState(device: device),
            isConfigMode: isConfigMode,
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
