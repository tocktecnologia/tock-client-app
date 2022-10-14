import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/data_user/data_user_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/water/chartWater.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';

const PADDING_HORIZ_EXTERN = 10.0;
const NUM_LAMPS_ROW = 4;

class WaterScreen extends StatefulWidget {
  const WaterScreen();

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservatórios"),
        // actions: [_iconLocal()],
        // leading: _iconRemote(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        primary: true,
        child: BlocBuilder<DataUserBloc, DataUserState>(
          builder: (context, state) {
            if (state is LoadedDataUserState) {
              return _content(state.dataUser.waterTanks);
            } else
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Não há reservatórios cadastrados ainda",
                    textAlign: TextAlign.center,
                  ),
                ],
              );
          },
        ),
      ),
    );
  }

  Widget _content(List<WaterTank> tanks) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: ColorsCustom.loginScreenMiddle,
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tanks
            .map((tank) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: ChartCircular(waterTank: tank),
                ))
            .toList(),
      ),
    );
  }
}
