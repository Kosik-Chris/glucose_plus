import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/main_pages/widgets.dart';
import 'package:glucose_plus/Connection/Bluetooth_Middleware/BluetoothController.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Bluetooth extends StatefulWidget{

  final BluetoothControl blueControl;
  Bluetooth(this.blueControl);

  @override
  _BluetoothState createState(){
    return new _BluetoothState(blueControl);
  }
}


class _BluetoothState extends State<Bluetooth> {

  _BluetoothState(
      this.blueControl
      );

  BluetoothControl blueControl;

//  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<String> readChar;
  String readValue = "temp";


  //Read Uuid

//  BluetoothCharacteristic readCharacter = new
//  BluetoothCharacteristic(uuid: null, serviceUuid: 6e400001-b5a3-f393-e0a9-e50e24dcca9e, descriptors: null,
//      properties: null);
  //Write UUID

//  /// Scanning
//  StreamSubscription scanSubscription;
//  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
//  bool isScanning = false;
//
//  /// State
//  StreamSubscription stateSubscription;
//  BluetoothState state = BluetoothState.unknown;
//
//  /// Device
//  BluetoothDevice device;
//  bool get isConnected => (device != null);
//  StreamSubscription deviceConnection;
//  StreamSubscription deviceStateSubscription;
//  List<BluetoothService> services = new List();
//  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
//
//  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;





  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue
    blueControl.flutterBlue.state.then((s) {
      setState(() {
        blueControl.state = s;
      });
    });
    // Subscribe to state changes
    blueControl.stateSubscription = blueControl.flutterBlue.onStateChanged().listen((s) {
      setState(() {
        blueControl.state = s;
      });
    });

  }

  @override
  void dispose() {
    blueControl.stateSubscription?.cancel();
    blueControl.stateSubscription = null;
    blueControl.scanSubscription?.cancel();
    blueControl.scanSubscription = null;
//    deviceConnection?.cancel();
//    deviceConnection = null;
    super.dispose();
  }

//  _startScan() {
//    scanSubscription = flutterBlue
//        .scan(
//      timeout: const Duration(seconds: 5),
//      /*withServices: [
//          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
//        ]*/
//    )
//        .listen((scanResult) {
//      print('localName: ${scanResult.advertisementData.localName}');
//      print(
//          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
//      print('serviceData: ${scanResult.advertisementData.serviceData}');
//      setState(() {
//        scanResults[scanResult.device.id] = scanResult;
//      });
//    }, onDone: _stopScan);
//
//    setState(() {
//      isScanning = true;
//    });
//  }


//
//  _stopScan() {
//    scanSubscription?.cancel();
//    scanSubscription = null;
//    setState(() {
//      isScanning = false;
//    });
//  }
//
//  _connect(BluetoothDevice d) async {
//    device = d;
//    // Connect to device
//    deviceConnection = flutterBlue
//        .connect(device, timeout: const Duration(seconds: 4))
//        .listen(
//      null,
//      onDone: _disconnect,
//    );
//
//    // Update the connection state immediately
//    device.state.then((s) {
//      setState(() {
//        deviceState = s;
//      });
//    });
//
//    // Subscribe to connection changes
//    deviceStateSubscription = device.onStateChanged().listen((s) {
//      setState(() {
//        deviceState = s;
//      });
//      if (s == BluetoothDeviceState.connected) {
//        device.discoverServices().then((s) {
//          setState(() {
//            services = s;
//          });
//        });
//      }
//    });
//  }
//
//  _disconnect() {
//    // Remove all value changed listeners
//    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
//    valueChangedSubscriptions.clear();
//    deviceStateSubscription?.cancel();
//    deviceStateSubscription = null;
//    deviceConnection?.cancel();
//    deviceConnection = null;
//    setState(() {
//      device = null;
//    });
//  }
//
//  _readCharacteristic(BluetoothCharacteristic c) async {
//    await device.readCharacteristic(c);
//    print(c.value.toString());
//    setState(() {
//    });
//  }
//
//  _writeCharacteristic(BluetoothCharacteristic c) async {
//
//
//    await device.writeCharacteristic(c, [0x1, 0x1],
//        type: CharacteristicWriteType.withResponse);
//    setState(() {
//    });
//  }
//
//  _readDescriptor(BluetoothDescriptor d) async {
//    await device.readDescriptor(d);
//    setState(() {});
//  }
//
//  _writeDescriptor(BluetoothDescriptor d) async {
//    await device.writeDescriptor(d, [0x1, 0x1]);
//    setState(() {});
//  }
//
//  _setNotification(BluetoothCharacteristic c) async {
//    if (c.isNotifying) {
//      await device.setNotifyValue(c, false);
//      // Cancel subscription
//      valueChangedSubscriptions[c.uuid]?.cancel();
//      valueChangedSubscriptions.remove(c.uuid);
//    } else {
//      await device.setNotifyValue(c, true);
//      // ignore: cancel_subscriptions
//      final sub = device.onValueChanged(c).listen((d) {
//        setState(() {
//          print('onValueChanged $d');
//        });
//      });
//      // Add to map
//      valueChangedSubscriptions[c.uuid] = sub;
//    }
//    setState(() {});
//  }
//
//  _refreshDeviceState(BluetoothDevice d) async {
//    var state = await d.state;
//    setState(() {
//      deviceState = state;
//      print('State refreshed: $deviceState');
//    });
//  }

  _buildScanningButton() {
    if (blueControl.isConnected || blueControl.state != BluetoothState.on) {
      return null;
    }
    if (blueControl.isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: (){
          blueControl.stopScan;
          setState(() {
            blueControl.isScanning = false;
          });
        },
        backgroundColor: Colors.red,
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search), onPressed: (){
            blueControl.startScan;

      });
    }
  }

  _buildScanResultTiles() {
    return blueControl.scanResults.values
        .map((s) => new ListTile(
      title: new Text(s.device.name),
      subtitle: new Text(s.device.id.toString()),
      leading: new Text(s.rssi.toString()),
      onTap: () => (){
        setState(() {
          blueControl.connect(s.device);
          blueControl.deviceState == BluetoothDeviceState.connected;
        });
      },
    ))
        .toList();
  }

//Widgets are flexible but highly nested!! declare variables elsewhere!!
  List<Widget> _buildServiceTiles() {
    return blueControl.services
        .map(
          (s) => new ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => new CharacteristicTile(
            characteristic: c,
            onReadPressed: () => blueControl.readCharacteristic(c),
            onWritePressed: () => blueControl.writeCharacteristic(c),
            onNotificationPressed: () => blueControl.setNotification(c),
            descriptorTiles: c.descriptors
                .map(
                  (d) => new DescriptorTile(
                descriptor: d,
                onReadPressed: () => blueControl.readDescriptor(d),
                onWritePressed: () =>
                    blueControl.writeDescriptor(d),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

//  Future<List<String>> _getReadData() async {
//    var reads = new List<String>();
//    reads.add(device.readCharacteristic(0x123).toString());
//    return reads;
//
//  }

  _buildActionButtons() {
    if (blueControl.isConnected) {
      return new ButtonBar(
        children: <Widget>[
          RaisedButton(
            onPressed: (){
              blueControl.disconnect();
            },
            child: Text("Disconnect"),
          ),
          RaisedButton(
            onPressed: (){
              //Use show dialog to get in infinite listview of read values?
              showDialog(context: context,
                builder: (BuildContext context){
                return AlertDialog(
                  content: new Text(readValue),
                  actions: <Widget>[
                    new FlatButton(onPressed: (){

                    }, child: Text("Read")),
                    new FlatButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Exit"))
                  ],
                );
                }
              );
            },
            child: Text("Read"),
          ),
          RaisedButton(
            onPressed: (){
              //Use show dialog to send basic values to MCU
              showDialog(context: context,
                builder: (BuildContext context){
                return AlertDialog(

                );
                }
              );
            },
            child: Text("Write"),
          ),
        ],
      );
    }
  }


  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${blueControl.state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildDeviceStateTile() {
    return new ListTile(
        leading: (blueControl.deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${blueControl.deviceState.toString().split('.')[1]}.'),
        subtitle: new Text('${blueControl.device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => blueControl.refreshDeviceState(blueControl.device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }

  _buildConnectedDeviceTile(){

    if(!blueControl.isConnected) {
      return new ListTile(
          title: new Text('No device is connected'),

      );
    }
    if(blueControl.isConnected){
      return new ListTile(
          leading: (blueControl.deviceState == BluetoothDeviceState.connected)
              ? const Icon(Icons.bluetooth_connected)
              : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${blueControl.deviceState.toString().split(',')[0]}.'),
      );
    }
    else{
      return new ListTile(
        title: new Text("Device disconnected"),
      );
    }
  }


  _buildProgressBarTile() {
    return new CircularProgressIndicator();
  }



  @override
  Widget build(BuildContext context) {
    var connectTiles = new List<Widget>();
//    var readTiles = new List<Widget>();
    //not sure how to read in values yet

    if (blueControl.state != BluetoothState.on) {
      connectTiles.add(_buildAlertTile());
    }
    if (blueControl.isConnected) {
      connectTiles.add(_buildDeviceStateTile());
      connectTiles.addAll(_buildServiceTiles());
      connectTiles.add(_buildActionButtons());
//      connectTiles.add(_buildActionButtons());
    } else {
      connectTiles.add(_buildConnectedDeviceTile());
      connectTiles.addAll(_buildScanResultTiles());
    }
    return new MaterialApp(
      home: new Scaffold(
/*        appBar: new AppBar(
          title: const Text('FlutterBlue'),
          actions: _buildActionButtons(),
        ),*/
        floatingActionButton: _buildScanningButton(),
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.cyanAccent),
            ),
            (blueControl.isScanning) ? _buildProgressBarTile() : new Container(),
//            (isConnected) ? _buildWriteOutput() : new Container(),
            new ListView(
              children: connectTiles,
            ),
//            new ListView(
//              children: readTiles,
//            ),
          ],
        ),
      ),
    );
  }
}
