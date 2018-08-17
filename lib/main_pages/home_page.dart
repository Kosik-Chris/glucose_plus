import 'package:glucose_plus/sub_pages/Account.dart';
import 'package:glucose_plus/sub_pages/BluetoothConfig.dart';
import 'package:glucose_plus/sub_pages/ChemicalConfig.dart';
import 'package:glucose_plus/sub_pages/NumericalResults.dart';
import 'package:glucose_plus/sub_pages/ChartResults.dart';
import 'package:glucose_plus/sub_pages/Export.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:glucose_plus/sub_pages/NewReading.dart';
import 'package:glucose_plus/sub_pages/Home.dart';
import 'package:flutter_simple_permissions/flutter_simple_permissions.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';


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
    new DrawerItem("Bluetooth config", Icons.settings_bluetooth),
    new DrawerItem("Chemical config", Icons.invert_colors),
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


  FlutterBlue _flutterBlue = FlutterBlue.instance;
  String connectedName = "";

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





  @override
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
//    deviceConnection?.cancel();
//    deviceConnection = null;
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





//  String _platformVersion = 'Unknown';
  bool isPermissionGranted;
  Permission permission = Permission.AccessCoarseLocation;

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

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildProgressBarTile() {
    return new CircularProgressIndicator();
  }

  _buildScanResultTiles() {
    return scanResults.values
        .map((s) => new ListTile(
      title: new Text(s.device.name),
      subtitle: new Text(s.device.id.toString()),
      leading: new Text(s.rssi.toString()),
      onTap: () {
        _connect(s.device);
        connectedName = s.device.name+" Connected";
        if(connectedName == null){
          connectedName = "Unknown name";
        }
      }
    ))
        .toList();
  }

  _buildBluetoothOption(){

    var connectTiles = new List<Widget>();
    if (state == BluetoothState.off) {
      connectTiles.add(_buildAlertTile());
    }
    if (state == BluetoothState.on) {
      connectTiles.addAll(_buildScanResultTiles());
    }

    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Stack(
              children: <Widget>[
                (isScanning) ? _buildProgressBarTile() : new Container(),
                new GestureDetector(
                  onTap: () => Navigator.pop(context),
                child: new ListView(
                  padding: EdgeInsets.only(top: 30.0),
                  children: connectTiles,
                ),
                ),
                new Text(connectedName),
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                _disconnect();
//                Navigator.pop(context);
              }, child: new Text("Disconnect")),
              new FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: new Text("Exit")),

            ],
          );
        }
    );

  }


  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < 8; i++) {
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
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title, style:
          new TextStyle(color: Colors.white),),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.invert_colors), tooltip: 'Configure Chemicals',
              splashColor: Colors.indigo, onPressed: (){
                setState(() {
                  _selectedDrawerIndex = 3;
                });
          }),
    new Switch(
      value: _bluetoothEnabled,
    onChanged: (bool value) {
     setState(() {
       //if switch is green
       if(_bluetoothEnabled = true) {
         if(state == BluetoothState.on) {
           if(deviceState == BluetoothDeviceState.disconnected) {
             _startScan();
             //bluetooth options will build alert tile if bluetooth not on
             _buildBluetoothOption();
           }
           else{
             _buildBluetoothOption();
           }
         }
         else{
           _buildBluetoothOption();
         }
       }
       //if switch is red
       if(_bluetoothEnabled = false){
         if(isConnected) {
           _disconnect();
           Scaffold.of(context).showSnackBar(SnackBar(content:
           new Text("Disconnected from device")));
         }
       }
       _bluetoothEnabled = value;
     });
      //check to see if bluetooth adapter is good
      // if bluetooth is off scan/ ask to scan

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
                accountName: new Text("John Snow"), accountEmail: new Text("JohnSnow@gmail.com")),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: getDrawerItemWidget(_selectedDrawerIndex),

    );
  }
}