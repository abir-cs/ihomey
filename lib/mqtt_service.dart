import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final client = MqttServerClient('192.168.1.34', 'FlutterClient');
  Function(String)? onTempUpdate;
  Function(String)? onHumidityUpdate;
  Future<void> connect() async {
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.onDisconnected = () => print('MQTT Disconnected');
    client.logging(on: false);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('FlutterClient')
        .startClean();
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print('Connected to MQTT');

      client.subscribe('sensor/temperature', MqttQos.atMostOnce);
      client.subscribe('sensor/humidity', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        if (c[0].topic == 'sensor/temperature') {
          onTempUpdate?.call(message);
        } else if (c[0].topic == 'sensor/humidity') {
          onHumidityUpdate?.call(message);
        }
      });
    } catch (e) {
      print('MQTT Error ❌ : $e');
    }
  }
}
