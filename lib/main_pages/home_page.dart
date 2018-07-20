import 'dart:async';

import 'package:glucose_plus/main_pages/widgets.dart';
import 'package:glucose_plus/sub_pages/Account.dart';
import 'package:glucose_plus/sub_pages/BluetoothConfig.dart';
import 'package:glucose_plus/sub_pages/ChemicalConfig.dart';
import 'package:glucose_plus/sub_pages/NumericalResults.dart';
import 'package:glucose_plus/sub_pages/ChartResults.dart';
import 'package:glucose_plus/sub_pages/Export.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:glucose_plus/sub_pages/Biometrics.dart';
import 'package:glucose_plus/sub_pages/Hb1acCalc.dart';
import 'package:glucose_plus/sub_pages/NewReading.dart';
import 'package:glucose_plus/sub_pages/Home.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/sub_pages/send_email.dart';

import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Glucose+  Home", Icons.home),
    new DrawerItem("Account", Icons.account_circle),
    new DrawerItem("Bluetooth configuration", Icons.settings_bluetooth),
    new DrawerItem("Chemical configuration", Icons.local_bar),
    new DrawerItem("New reading", Icons.track_changes),
    new DrawerItem("Numerical results", Icons.traffic),
    new DrawerItem("Chart results", Icons.insert_chart),
    new DrawerItem("Export", Icons.send),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  //TODO: Implement auto ask to connect upon program load/login
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }



  _startScan() {
    _scanSubscription = _flutterBlue
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
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
      null,
      onDone: _disconnect,
    );

    // Update the connection state immediately
    device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      setState(() {
        deviceState = s;
      });
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          setState(() {
            services = s;
          });
        });
      }
    });
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      device = null;
    });
  }

  _readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
    setState(() {});
  }

  _writeCharacteristic(BluetoothCharacteristic c) async {
    await device.writeCharacteristic(c, [0x12, 0x34],
        type: CharacteristicWriteType.withResponse);
    setState(() {});
  }

  _readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
    setState(() {});
  }

  _writeDescriptor(BluetoothDescriptor d) async {
    await device.writeDescriptor(d, [0x12, 0x34]);
    setState(() {});
  }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
        setState(() {
          print('onValueChanged $d');
        });
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
    setState(() {});
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    setState(() {
      deviceState = state;
      print('State refreshed: $deviceState');
    });
  }

  _buildScanResultTiles() {
    return scanResults.values
        .map((s) => new ListTile(
      title: new Text(s.device.name),
      subtitle: new Text(s.device.id.toString()),
      leading: new Text(s.rssi.toString()),
      onTap: () => _connect(s.device),
    ))
        .toList();
  }

  List<Widget> _buildServiceTiles() {
    return services
        .map(
          (s) => new ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => new CharacteristicTile(
            characteristic: c,
            onReadPressed: () => _readCharacteristic(c),
            onWritePressed: () => _writeCharacteristic(c),
            onNotificationPressed: () => _setNotification(c),
            descriptorTiles: c.descriptors
                .map(
                  (d) => new DescriptorTile(
                descriptor: d,
                onReadPressed: () => _readDescriptor(d),
                onWritePressed: () =>
                    _writeDescriptor(d),
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

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  _buildDeviceStateTile() {
    return new ListTile(
        leading: (deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),
        subtitle: new Text('${device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }


  int _selectedDrawerIndex = 0;
  int selectedOverride = 0;
  bool _bluetoothEnabled = false;

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new Account();
      case 2:
        return new Bluetooth();
      case 3:
        return new ChemicalsMain();
      case 4:
        return new NewReading();
      case 5:
        return new Numerical();
      case 6:
        return new Charts();
      case 7:
        return new Export();
      case 8:
        return new NewResults();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < 7; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.local_bar), tooltip: 'Configure Chemicals',
              splashColor: Colors.indigo, onPressed: (){
                setState(() {
                  _selectedDrawerIndex = 3;
                });
          }),
    new Switch(
    value: _bluetoothEnabled,
    onChanged: (bool value) {
      var connectTiles = new List<Widget>();
      if (isConnected) {
        connectTiles.add(_buildDeviceStateTile());
        connectTiles.addAll(_buildServiceTiles());
//      connectTiles.add(_buildActionButtons());
      } else {
        connectTiles.addAll(_buildScanResultTiles());
      }
      PopupMenuItem<Widget>(

      );

    setState(() {
    _bluetoothEnabled = value;
    },

    );
    },
    activeThumbImage: AssetImage('baseline-bluetooth_connected-24px.png'),
      activeColor: Colors.green,
      inactiveThumbImage: AssetImage('baseline-bluetooth_disabled-24px.png'),
      inactiveThumbColor: Colors.red,
    ),
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            new UserAccountsDrawerHeader(
                accountName: new Text("John Doe"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: getDrawerItemWidget(_selectedDrawerIndex),

    );
  }
}