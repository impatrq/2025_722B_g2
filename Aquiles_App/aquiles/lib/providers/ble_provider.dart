// lib/providers/ble_provider.dart
import 'package:aquiles/services/ble_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

final flutterBleProvider = Provider<FlutterReactiveBle>((ref) {
  return FlutterReactiveBle();
});

final bleServiceProvider = Provider<BleService>((ref) {
  final ble = ref.watch(flutterBleProvider);
  return BleService(
    ble,
    Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"), // service UUID
    Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"), // TX (App -> ESP32)
    Uuid.parse(
        "6e400002-b5a3-f393-e0a9-e50e24dcca9e"), // RX (ESP32 -> App) - SAME UUID!
  );
});

final notificationStreamProvider = StreamProvider<String>((ref) {
  final ble = ref.watch(bleServiceProvider);
  return ble.getNotificationStream();
});
