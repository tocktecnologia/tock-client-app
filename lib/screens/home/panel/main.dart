import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/data_user/data_user_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/panel/tock_device.dart';
import 'package:flutter_login_setup_cognito/shared/services/wifi.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reorderables/reorderables.dart';

const PADDING_HORIZ_INTERN = 10.0;
const PADDING_HORIZ_EXTERN = 10.0;
const NUM_LAMPS_ROW = 3;

class PanelScreen extends StatefulWidget {
  @override
  _PanelScreenState createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  List<TockDevice> _devices;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LightsBloc>(context).add(GetStatesLight());
    //updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel"),
        actions: [_iconLocal()],
        leading: _iconRemote(),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return updateState();
        },
        child: _panelLights(),
      ),
    );
  }

  Future<String> updateState() async {
    BlocProvider.of<LightsBloc>(context).add(GetStatesLight());
    return "sucesso";
  }

  Widget _panelLights() {
    return BlocBuilder<LightsBloc, LightsState>(
      condition: (prevState, state) {
        if (state is LoadLightStatesError) {
          ShowAlert.open(
              context: context,
              contentText: "Erro buscando estados: ${state.message}");
        }
        return;
      },
      builder: (context, state) {
        if (state is LoadingLightStates) {
          return SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
                Text("Atualizando ...",
                    style: TextStyle(
                        color: ColorsCustom.loginScreenUp, fontSize: 16))
              ],
            ),
          );
        } else if (state is LoadedLightStates) {
          return _cardDevices();
        } else {
          return Center(child: Text('Central não encontrada'));
        }
      },
    );
  }

  Widget _cardDevices() {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: PADDING_HORIZ_EXTERN, vertical: 10),
        child: Container(
          decoration: new BoxDecoration(boxShadow: [
            new BoxShadow(
              color: ColorsCustom.loginScreenMiddle,
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ]),
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
                child: _listWrapReorderable()),
          ),
        ),
      ),
    );
  }

  Widget _listWrapReorderable() {
    final dataUser = BlocProvider.of<DataUserBloc>(context).dataUser;
    final devices =
        dataUser.devices.map<TockDevice>((v) => TockDevice(device: v)).toList();

    return ReorderableWrap(
      spacing: (MediaQuery.of(context).size.width -
              3 * SIZE_WIDTH_LAMP -
              2 * PADDING_HORIZ_EXTERN -
              2 * PADDING_HORIZ_INTERN) /
          (NUM_LAMPS_ROW - 1),
      runSpacing: 20,
      padding: EdgeInsets.only(top: 20, bottom: 10),
      children: devices,
      onReorder: _onReorder,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    BlocProvider.of<DataUserBloc>(context)
        .add(UpdateIdxDataUserEvent(oldIndex: oldIndex, newIndex: newIndex));
  }

  Widget _iconRemote() {
    // bool hasInternet = Locator.instance.get<WifiService>().connectivityResult !=
    //     ConnectivityResult.none;
    return BlocProvider.of<AuthBloc>(context).isConnectedRemote
        ? Icon(Icons.cloud_done, color: Colors.white)
        : Icon(Icons.cloud_off, color: Colors.white30);
  }

  Widget _iconLocal() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: BlocProvider.of<AuthBloc>(context).isConnectedLocal
            ? Icon(Icons.wifi_tethering, color: Colors.white)
            : Icon(Icons.portable_wifi_off, color: Colors.white30));
  }
}
