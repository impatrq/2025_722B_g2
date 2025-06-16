import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final flutterReactiveBle = FlutterReactiveBle();

  late DiscoveredDevice connectedDevice;
  late QualifiedCharacteristic txChar;

  final serviceUuid = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
  final charTxUuid = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");

  Future<void> scanAndConnect() async {
    await for (final device in flutterReactiveBle.scanForDevices(
      withServices: [serviceUuid],
      scanMode: ScanMode.lowLatency,
    )) {
      if (device.name == "Aquiles X1") {
        connectedDevice = device;
        flutterReactiveBle
            .connectToDevice(id: device.id)
            .listen((_) {}, onError: print);
        txChar = QualifiedCharacteristic(
          serviceId: serviceUuid,
          characteristicId: charTxUuid,
          deviceId: device.id,
        );
        break;
      }
    }
  }

  Future<void> sendCommand(String command) async {
    await flutterReactiveBle.writeCharacteristicWithResponse(
      txChar,
      value: command.codeUnits,
    );
  }
}
