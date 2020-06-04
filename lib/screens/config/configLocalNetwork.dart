import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/local_network/local_network_bloc.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/components.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConfigLocalNetworkScreen extends StatefulWidget {
  @override
  _ConfigLocalNetworkScreenState createState() =>
      _ConfigLocalNetworkScreenState();
}

class _ConfigLocalNetworkScreenState extends State<ConfigLocalNetworkScreen> {
  bool isEnableLocal = false;

  @override
  void initState() {
    super.initState();

    //BlocProvider.of<LocalNetworkBloc>(context).add(VerifyLocalConnection());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuração Local"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //_titleConnetion(),
          //Divider(height: 20),
          _modeOperation()
        ],
      ),
    );
  }

  // Widget _titleConnetion() {
  //   final titleStyle =
  //       TextStyle(fontSize: 19, color: ColorsCustom.loginScreenUp);
  //   final titleStyleSub =
  //       TextStyle(fontSize: 16, color: ColorsCustom.loginScreenUp);

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
  //     child: Center(
  //       child: BlocBuilder<LocalNetworkBloc, LocalNetworkState>(
  //         builder: (context, state) {
  //           if (state is VerifingLocalConnenction) {
  //             return Column(
  //               children: <Widget>[
  //                 SpinKitWave(color: ColorsCustom.loginScreenUp),
  //                 Text("Verificando conexão com a central"),
  //               ],
  //             );
  //           } else if (state is LocalDisconnected) {
  //             return Column(
  //               children: <Widget>[
  //                 Text(
  //                   "Você ainda não está conectado na rede da central. Tente conectar-se na rede TOCK AUTO e tente novamente.",
  //                   style: titleStyle,
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 30),
  //                 ButtonLogin(
  //                   label: "Conectar",
  //                   labelColor: Colors.white,
  //                   backgroundColor: ColorsCustom.loginScreenUp,
  //                   mOnPressed: () => BlocProvider.of<LocalNetworkBloc>(context)
  //                       .add(VerifyLocalConnection()),
  //                 )
  //               ],
  //             );
  //           } else if (state is LocalConnected) {}
  //           return Column(
  //             children: <Widget>[
  //               Text("Central conectada!",
  //                   style: titleStyle, textAlign: TextAlign.center),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _modeOperation() {
    final titleStyleSub =
        TextStyle(fontSize: 16, color: ColorsCustom.loginScreenUp);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
      child: Column(
        children: <Widget>[
          Text("Deseja mudar o modo de operação para a rede local?",
              style: titleStyleSub, textAlign: TextAlign.center),
          SizedBox(height: 20),
          SizedBox(
            width: 70,
            child: _currentStateSwitch(),
          ),
          Divider(height: 30),
          ButtonLogin(
            label: "Salvar",
            labelColor: Colors.white,
            backgroundColor: ColorsCustom.loginScreenUp,
            mOnPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _currentStateSwitch() {
    return BlocBuilder<LocalConfigBloc, ConfigState>(
      builder: (BuildContext context, ConfigState state) {
        return Switch(
          value: state.value,
          onChanged: (value) {
            value
                ? BlocProvider.of<LocalConfigBloc>(context)
                    .add(ConfigEvent.enableLocal)
                : BlocProvider.of<LocalConfigBloc>(context)
                    .add(ConfigEvent.disableLocal);
          },
        );
      },
    );
  }
}
