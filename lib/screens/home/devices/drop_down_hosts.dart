import 'package:client/bloc/mqtt/mqtt_bloc.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String remote = "remoto";
const String local = "local";

const Map hostNames = {
  "AWS": MqttSecrets.awsHost,
  "local": MqttSecrets.localHost
};
const List<String> list = <String>["AWS", "local"];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.wifi_rounded, color: Colors.white),
      ),
      dropdownColor: ColorsCustom.loginScreenMiddle,
      elevation: 5,
      focusColor: ColorsCustom.loginScreenMiddle.withOpacity(0.9),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      underline: Container(),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });

        context.read<MqttCubit>().changeHost(hostNames[value]);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
