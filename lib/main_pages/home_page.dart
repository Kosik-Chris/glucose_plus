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
import 'package:glucose_plus/Connection/Bluetooth_Middleware/BluetoothController.dart';
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

  BluetoothControl blueControl = new BluetoothControl();
  String connectedName = "";



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
        return new Bluetooth(blueControl);
      case 2:
        return new ChemicalsMain();
      case 3:
        return new NewReading(blueControl);
      case 4:
        return new Numerical();
      case 5:
        return new Charts();
      case 6:
        return new Export();
      case 7:
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

  _buildProgressBarTile() {
    return new CircularProgressIndicator();
  }

  _buildScanResultTiles() {
    return blueControl.scanResults.values
        .map((s) => new ListTile(
      title: new Text(s.device.name),
      subtitle: new Text(s.device.id.toString()),
      leading: new Text(s.rssi.toString()),
      onTap: () {
        blueControl.connect(s.device);
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
    if (blueControl.state == BluetoothState.off) {
      connectTiles.add(_buildAlertTile());
    }
    if (blueControl.state == BluetoothState.on) {
      connectTiles.addAll(_buildScanResultTiles());
    }

    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Stack(
              children: <Widget>[
                (blueControl.isScanning) ? _buildProgressBarTile() : new Container(),
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
                blueControl.disconnect();
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
         if(blueControl.state == BluetoothState.on) {
           if(blueControl.deviceState == BluetoothDeviceState.disconnected) {
             blueControl.startScan();
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
         if(blueControl.isConnected) {
           blueControl.disconnect();
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

            new DrawerHeader(
              child: Image(image: AssetImage("sensor_pic.jpg"))
                ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: getDrawerItemWidget(_selectedDrawerIndex),

    );
  }
}