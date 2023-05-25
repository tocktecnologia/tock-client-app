import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/mqtt_connect/mqtt_connect_bloc.dart';
import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Map<String, String> hostNames = {
  MqttSecrets.awsHost: "Nuvem",
  MqttSecrets.localHost: "Local",
};
const List<String> list = <String>[MqttSecrets.localHost, MqttSecrets.awsHost];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  void initState() {
    dropdownValue =
        context.read<MqttConnectCubit>().host ?? MqttSecrets.awsHost;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataUserCubit, DataUserState>(
      builder: (context, state) {
        if (state is LoadedDataUserState) {
          return _dropDownHost(state.dataUser.devices!);
        } else {
          return DropdownButton<String>(
            items: const [],
            onChanged: null,
          );
        }
      },
    );
  }

  Widget _dropDownHost(List<Device> devices) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _iconConnection(),
      ),
      dropdownColor: ColorsCustom.loginScreenMiddle,
      elevation: 5,
      focusColor: ColorsCustom.loginScreenMiddle.withOpacity(0.1),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      underline: Container(),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });

        context.read<MqttConnectCubit>().mqttConnect(devices, host: value!);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(hostNames[value]!),
        );
      }).toList(),
    );
  }

  Widget _iconConnection() {
    return BlocBuilder<MqttConnectCubit, MqttConnectState>(
        builder: (context, state) {
      if (state is ConnectedMqttState) {
        return const Icon(Icons.wifi_rounded, color: Colors.white);
      } else {
        return const Icon(Icons.wifi_off_rounded, color: Colors.white);
      }
    });
  }
}
