import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/main_pages/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class BluetoothControl {


  FlutterBlue flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription stateSubscription;
  //plan is to cancel from within whatever method is calling
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;

  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};

  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  startScan() {
    scanSubscription = flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
      /*withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]*/
    )
        .listen((scanResult) {
      print('localName: ${scanResult.advertisementData.localName}');
      print(
          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      print('serviceData: ${scanResult.advertisementData.serviceData}');
      scanResults[scanResult.device.id] = scanResult;
    }, onDone: stopScan);

    isScanning = true;
  }

  stopScan() {
    scanSubscription?.cancel();
    scanSubscription = null;
    isScanning = false;
  }

  connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
      null,
      onDone: disconnect,
    );
    // Update the connection state immediately
    device.state.then((s) {
      deviceState = s;
    });
    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      deviceState = s;

      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          services = s;
        });
      }
    });
  }

  disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    device = null;
  }

  readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
    print(c.value.toString());
  }

  writeCharacteristic(BluetoothCharacteristic c) async {


    await device.writeCharacteristic(c, [0x1, 0x1],
        type: CharacteristicWriteType.withResponse);
  }

  readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
  }

  writeDescriptor(BluetoothDescriptor d) async {
    await device.writeDescriptor(d, [0x1, 0x1]);
  }

  setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
          print('onValueChanged $d');
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }

  }

  refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
      deviceState = state;
      print('State refreshed: $deviceState');
  }



}