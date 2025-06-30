import 'dart:async';
import 'dart:convert';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final FlutterReactiveBle _ble;
  final Uuid serviceUuid;
  final Uuid txUuid;
  final Uuid rxUuid;

  DiscoveredDevice? _device;
  QualifiedCharacteristic? _txChar;
  QualifiedCharacteristic? _rxChar;

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<List<int>>? _notificationSubscription;
  final _notificationController = StreamController<String>.broadcast();

  BleService(this._ble, this.serviceUuid, this.txUuid, this.rxUuid);

  Future<bool> connectToDevice(String nameToFind) async {
    final scanStream = _ble.scanForDevices(withServices: [serviceUuid]);

    await for (final device in scanStream) {
      if (device.name == nameToFind) {
        _device = device;

        final completer = Completer<bool>();

        _connectionSubscription = _ble.connectToDevice(
          id: device.id,
          servicesWithCharacteristicsToDiscover: {
            serviceUuid: [txUuid, rxUuid]
          },
        ).listen((event) async {
          if (event.connectionState == DeviceConnectionState.connected) {
            _txChar = QualifiedCharacteristic(
              deviceId: device.id,
              serviceId: serviceUuid,
              characteristicId: txUuid,
            );
            _rxChar = QualifiedCharacteristic(
              deviceId: device.id,
              serviceId: serviceUuid,
              characteristicId: rxUuid,
            );

            _notificationSubscription =
                _ble.subscribeToCharacteristic(_rxChar!).listen((data) {
              final message = utf8.decode(data);
              print('Mensaje recibido: $message');
              _notificationController.add(message);
            });
            final services = await _ble.discoverServices(device.id);
            for (var service in services) {
              print('Service: ${service.serviceId}');
              for (var char in service.characteristics) {
                print('Characteristic: ${char.characteristicId}');
              }
            }

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
      await _ble.writeCharacteristicWithResponse(
        _txChar!,
        value: utf8.encode(command),
      );
    }
  }

  Stream<String> getNotificationStream() {
    return _notificationController.stream;
  }

  Future<void> disconnect() async {
    await _notificationSubscription?.cancel();
    await _connectionSubscription?.cancel();
    _notificationController.close();
  }
}
