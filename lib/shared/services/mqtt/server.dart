import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient setup(String serverAddress, String uniqueID, int port) {
  return MqttServerClient.withPort(serverAddress, uniqueID, port);
}
