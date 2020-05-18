import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/panel/light_widget.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LightsBloc>(context).add(GetStatesLight());
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
      body: Center(child: _cardLights()),
    );
  }

  Widget _cardLights() {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: PADDING_HORIZ_EXTERN, vertical: 20),
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
            margin: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 85),
                    Text(
                      "Iluminação",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsCustom.loginScreenMiddle,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () => BlocProvider.of<LightsBloc>(context)
                          .add(GetStatesLight()),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Icon(
                          Icons.update,
                          size: 27,
                          color: ColorsCustom.loginScreenUp,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 0)),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
                    child: _lights()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lights() {
    return BlocBuilder<LightsBloc, LightsState>(condition: (prevState, state) {
      if (state is LoadLightStatesError) {
        ShowAlert.open(
            context: context,
            contentText: "Erro buscando estados: ${state.message}");
      }
      return;
    }, builder: (context, state) {
      if (state is LoadingLightStates) {
        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitRipple(size: 30, color: ColorsCustom.loginScreenUp),
              SizedBox(height: 50),
              Text(
                "Atualizando ...",
                style:
                    TextStyle(color: ColorsCustom.loginScreenUp, fontSize: 16),
              ),
              SizedBox(height: 700),
            ],
          ),
        );
      } else {
        return _listWrapReorderable();
      }
    });
  }

  Widget _listWrapReorderable() {
    final lights = BlocProvider.of<LightsBloc>(context).lights;
    final tockLights =
        lights.map<TockLight>((light) => TockLight(light: light)).toList();

    return ReorderableWrap(
      spacing: (MediaQuery.of(context).size.width -
              3 * SIZE_WIDTH_LAMP -
              2 * PADDING_HORIZ_EXTERN -
              2 * PADDING_HORIZ_INTERN) /
          (NUM_LAMPS_ROW - 1),
      runSpacing: 20,
      padding: EdgeInsets.only(top: 20, bottom: 10),
      children: tockLights,
      onReorder: _onReorder,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    BlocProvider.of<LightsBloc>(context)
        .add(UpdateIdxLightsEvent(oldIndex: oldIndex, newIndex: newIndex));
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
