import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'mqtt_message_state.dart';

class MqttMessageCubit extends Cubit<MqttMessageState> {
  MqttMessageCubit() : super(MqttMessageInitial());

  Future<void> mqttPublish(String message, String topic) async {}
}
