// lib/services/ble_service.dart
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final FlutterReactiveBle _ble;
  final Uuid serviceUuid;
  final Uuid txUuid;

  DiscoveredDevice? _device;
  QualifiedCharacteristic? _txChar;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  BleService(this._ble, this.serviceUuid, this.txUuid);

  Future<bool> connectToDevice(String nameToFind) async {
    final scanStream = _ble.scanForDevices(withServices: [serviceUuid]);

    await for (final device in scanStream) {
      if (device.name == nameToFind) {
        _device = device;

        final completer = Completer<bool>();

        _connectionSubscription = _ble.connectToDevice(
          id: device.id,
          servicesWithCharacteristicsToDiscover: {
            serviceUuid: [txUuid]
          },
        ).listen((event) {
          if (event.connectionState == DeviceConnectionState.connected) {
            _txChar = QualifiedCharacteristic(
              deviceId: device.id,
              serviceId: serviceUuid,
              characteristicId: txUuid,
            );
            completer.complete(true);
          } else if (event.connectionState ==
              DeviceConnectionState.disconnected) {
            completer.complete(false);
          }
        });

        return completer.future;
      }
    }

    return false;
  }

  Future<void> send(String command) async {
    if (_txChar != null) {
      await _ble.writeCharacteristicWithResponse(_txChar!,
          value: command.codeUnits);
    }
  }

  Future<void> disconnect() async {
    await _connectionSubscription?.cancel();
  }
}
