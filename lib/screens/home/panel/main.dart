import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/data_user/data_user_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/panel/tock_device.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:reorderables/reorderables.dart';

const PADDING_HORIZ_LAMPS = 20.0;
const NUM_LAMPS_ROW = 3;

class PanelScreen extends StatefulWidget {
  @override
  _PanelScreenState createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  List<TockDevice> _devices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel"),
        actions: [_iconLocal()],
        leading: _iconRemote(),
        centerTitle: true,
      ),
      body: BlocBuilder<DataUserBloc, DataUserState>(builder: (context, state) {
        if (state is LoadedDataUserState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZ_LAMPS),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: _wrapReorderable(),
            ),
          );
        } else {
          return Center(
            child: Text(
              "Você ainda não configurou seus devices!",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsCustom.loginScreenUp, fontSize: 20),
            ),
          );
        }
      }),
    );
  }

  Widget _wrapReorderable() {
    final dataUser = BlocProvider.of<DataUserBloc>(context).dataUser;
    final devices =
        dataUser.devices.map<TockDevice>((v) => TockDevice(device: v)).toList();

    return ReorderableWrap(
      spacing: (MediaQuery.of(context).size.width -
              3 * SIZE_WIDTH_LAMP -
              2 * PADDING_HORIZ_LAMPS) /
          (NUM_LAMPS_ROW - 1),
      runSpacing: 20,
      padding: EdgeInsets.only(top: 20, bottom: 10),
      children: devices,
      //  List.generate(devices.length, (int index) {
      //   return InkWell(
      //     child: devices[index],
      //     onTap: () => print("oi eu sou $index"),
      //   );
      // }),
      onReorder: _onReorder,
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    BlocProvider.of<DataUserBloc>(context)
        .add(UpdateIdxDataUserEvent(oldIndex: oldIndex, newIndex: newIndex));
  }

  Widget _iconRemote() {
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
