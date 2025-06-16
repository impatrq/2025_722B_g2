import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final flutterReactiveBle = FlutterReactiveBle();

  DiscoveredDevice? _connectedDevice;
  QualifiedCharacteristic? _txChar;

  // Make sure these UUIDs are correct for your device
  final Uuid _serviceUuid = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
  final Uuid _charTxUuid = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  Future<bool> scanAndConnect() async {
    // Cancel any existing subscriptions
    await _scanSubscription?.cancel();
    await _connectionSubscription?.cancel();
    _connectedDevice = null;
    _txChar = null;

    final completer = Completer<bool>();

    _scanSubscription = flutterReactiveBle.scanForDevices(
      withServices: [_serviceUuid],
      scanMode: ScanMode.lowLatency,
    ).listen((device) async {
      if (device.name == "Aquiles X1") {
        await _scanSubscription?.cancel(); // Stop scanning once found
        _connectedDevice = device;

        _connectionSubscription = flutterReactiveBle
            .connectToDevice(
          id: device.id,
          servicesWithCharacteristicsToDiscover: {
            _serviceUuid: [_charTxUuid]
          },
          connectionTimeout: const Duration(seconds: 10),
        )
            .listen((connectionStateUpdate) {
          if (connectionStateUpdate.connectionState ==
              DeviceConnectionState.connected) {
            _txChar = QualifiedCharacteristic(
              serviceId: _serviceUuid,
              characteristicId: _charTxUuid,
              deviceId: device.id,
            );
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          } else if (connectionStateUpdate.connectionState ==
                  DeviceConnectionState.disconnected ||
              connectionStateUpdate.connectionState ==
                  DeviceConnectionState.disconnecting) {
            print(
                'Device disconnected: ${connectionStateUpdate.failure?.message}');
            _connectionSubscription?.cancel();
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          }
        }, onError: (dynamic error) {
          print('Connection error: $error');
          _connectionSubscription?.cancel();
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        });
      }
    }, onError: (dynamic error) {
      print('Scan error: $error');
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    // Timeout for the scan itself in case the device is not found
    Future.delayed(const Duration(seconds: 20), () {
      if (!completer.isCompleted) {
        _scanSubscription?.cancel();
        _connectionSubscription?.cancel();
        print('Scan and connect overall timeout');
        completer.complete(false);
      }
    });

    return completer.future;
  }

  Future<void> sendCommand(String command) async {
    if (_txChar == null || _connectedDevice == null) {
      print(
          "Error: Device not connected or TX characteristic not initialized.");
      return;
    }
    try {
      await flutterReactiveBle.writeCharacteristicWithResponse(
        _txChar!,
        value: command.codeUnits,
      );
      print('Command "$command" sent successfully.');
    } catch (e) {
      print('Error sending command "$command": $e');
      // Consider attempting to reconnect or notifying the user
    }
  }

  Future<void> disconnect() async {
    await _connectionSubscription?.cancel();
    if (_connectedDevice != null) {
      // The flutter_reactive_ble library handles disconnection implicitly
      // when the subscription to connectToDevice is cancelled or when the app closes.
      // Explicit disconnect call might not be available or needed depending on library version and behavior.
      // For now, we ensure subscriptions are cancelled and state is reset.
      print('Disconnected from ${_connectedDevice!.name}');
    }
    _connectedDevice = null;
    _txChar = null;
  }

  // Optional: Stream to listen to connection state changes from outside the service
  Stream<ConnectionStateUpdate>? get connectionStateStream {
    if (_connectedDevice == null) return null;
    return flutterReactiveBle.connectToDevice(
      id: _connectedDevice!.id,
      servicesWithCharacteristicsToDiscover: {
        _serviceUuid: [_charTxUuid]
      },
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  bool get isConnected => _connectedDevice != null && _txChar != null;
}
