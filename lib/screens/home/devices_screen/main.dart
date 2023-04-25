import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/mqtt/mqtt_bloc.dart';
import 'package:client/screens/home/devices_screen/drop_down_hosts.dart';
import 'package:client/shared/services/api/user_aws.dart';
import 'package:client/shared/services/mqtt/mqtt_service.dart';
import 'package:client/shared/utils/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const PADDING_HORIZ_INTERN = 10.0;
const PADDING_HORIZ_EXTERN = 10.0;
const NUM_LAMPS_ROW = 4;

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
    // isLocalEnabled = BlocProvider.of<LocalConfigBloc>(context).state.value;
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
    //     context.read<MqttCubit>().mqttConnect();
    //   }
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel"),
        actions: [_iconLocal()],
        leading: _iconRemote(),
        centerTitle: true,
      ),
      body: _cardLights(),
    );
  }

  _updateStates() async {
    // context
    //     .read<MqttCubit>()
    //     .mqttPublish("/test", "{\"message\":\"debug bloc\"}");
    // Locator.instance
    //     .get<MqttService>()
    //     .awsClient
    //     ?.publishMessage("/test", "{\"message\":\"teste\"}");

    // final dataUser = await Locator.instance.get<AwsApi>().getDataUser();
    // print(dataUser);
    // await testMosquitto();
    // if (isLocalEnabled) {
    //   final lights = BlocProvider.of<LightsBloc>(context).lights;
    //   BlocProvider.of<CentralBloc>(context)
    //       .add(GetUpdateLightsFromCentralEvent(lights: lights));
    // } else {
    //   final AwsIot awsIot = Locator.instance.get<AwsIot>();
    //   final status = awsIot.awsIotDevice.client.connectionStatus.state;
    //   print('status connection : $status');
    //   print('_updateStatesFromShadow()');
    //   if (status == MqttConnectionState.connected) {
    //     BlocProvider.of<IotAwsBloc>(context)
    //         .add(GetUpdateLightsFromShadowEvent());
    //     // BlocProvider.of<IotAwsBloc>(context)
    //     //     .add(GetUpdateLightsFromNodeCentralEvent());
    //   } else if (status == MqttConnectionState.disconnected) {
    //     BlocProvider.of<IotAwsBloc>(context).add(ConnectIotAwsEvent());
    //     BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
    //     Navigator.pushReplacement(context, SizeRoute(page: LoginScreen()));
    //   }
    // }
  }

  Widget _cardLights() {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: PADDING_HORIZ_EXTERN, vertical: 20),
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
                  child: Divider(height: 0)),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: PADDING_HORIZ_INTERN),
                  child: _panelLights()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelLights() {
    return BlocBuilder<DataUserCubit, DataUserState>(
      builder: (context, state) {
        if (state is LoadingDataUserState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Center(
                child:
                    SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Recuperando Estados  ... ",
                    style: TextStyle(
                        fontSize: 17, color: ColorsCustom.loginScreenUp)),
              ),
            ],
          );
        } else if (state is LoadedDataUserState) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('Você tem ${state.dataUser.devices?.length} devices'),
          );
        } else {
          return Container();
        }
      },
    );

    // return BlocBuilder<LightsBloc, LightsState>(
    //   builder: (context, state) {
    //     if (state is UpdatingDevicesState ||
    //         state is UpdatingDevicesFromAwsState) {
    //       return Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: <Widget>[
    //           Center(
    //             child:
    //                 SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
    //           ),
    //           SizedBox(height: 20),
    //           Text("Recuperando Estados  ... ",
    //               style: TextStyle(
    //                   fontSize: 17, color: ColorsCustom.loginScreenUp)),
    //         ],
    //       );
    //     } else if (state is UpdatedDevicesState) {
    //       if (!isLocalEnabled) {
    //         return iotConnectionDevices(state);
    //       } else {
    //         print('asking central...');
    //         return centralConnectionDevices(state);
    //       }
    //     } else
    //       return Padding(
    //         padding: const EdgeInsets.all(30.0),
    //         child: Text('Você ainda não confgurou seus dispositivos!'),
    //       );
    //   },
    // );
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
    return BlocBuilder<MqttCubit, MqttState>(builder: (context, state) {
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

  // Widget _listWrapReorderable(state) {
  //   // final lights = BlocProvider.of<LightsBloc>(context).lights;
  //   final tockLights = state.lights
  //       .map<TockDevice>(
  //           (light) => TockDevice(light: light, isConfigMode: isConfigMode))
  //       .toList();

  //   return ReorderableWrap(
  //     spacing: (MediaQuery.of(context).size.width -
  //             NUM_LAMPS_ROW * SIZE_WIDTH_LAMP -
  //             2 * PADDING_HORIZ_EXTERN -
  //             2 * PADDING_HORIZ_INTERN) /
  //         (NUM_LAMPS_ROW - 1),
  //     runSpacing: 20,
  //     padding: EdgeInsets.only(top: 20, bottom: 10),
  //     children: tockLights,
  //     onReorder: _onReorder,
  //   );
  // }

  // void _onReorder(int oldIndex, int newIndex) {
  //   // get lights
  //   final lights = BlocProvider.of<LightsBloc>(context).lights;

  //   // change index
  //   final w = lights.removeAt(oldIndex);
  //   lights.insert(newIndex, w);

  //   // update  lights in bloc
  //   BlocProvider.of<LightsBloc>(context).setLights(lights);

  //   //update view
  //   setState(() {});
  // }

  Widget _iconRemote() {
    return const Icon(Icons.cloud_off, color: Colors.white30);
    // return BlocProvider.of<AuthBloc>(context).isConnectedRemote
    //     ? const Icon(Icons.cloud_done, color: Colors.white)
    //     : const Icon(Icons.cloud_off, color: Colors.white30);
  }

  Widget _iconLocal() {
    return InkWell(
      onTap: () {
        // BlocProvider.of<MqttCubit>(context).setHost(MqttSecrets.localhost);
        context.read<MqttCubit>().changeHost(MqttSecrets.localHost);
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
