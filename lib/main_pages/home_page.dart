import 'dart:async';
import 'package:flutter/services.dart';
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
import 'package:flutter_simple_permissions/flutter_simple_permissions.dart';

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
    new DrawerItem("Chemical configuration", Icons.invert_colors),
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
  String _platformVersion = 'Unknown';
  bool isPermissionGranted;
  Permission permission = Permission.AccessCoarseLocation;

  int _selectedDrawerIndex = 0;
  int selectedOverride = 0;
  bool _bluetoothEnabled = false;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimplePermissions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


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

  requestPermission() async {

    if (await FlutterSimplePermissions.checkPermission(permission)) {
      isPermissionGranted = true;
    }
    else {
       if(await FlutterSimplePermissions.requestPermission(permission)){
         isPermissionGranted = true;
       } else {
         isPermissionGranted = false;
       }
       }
      print("Bluetooth location permission granted  $isPermissionGranted");
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
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
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
       requestPermission();
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
                accountName: new Text("John Doe"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: getDrawerItemWidget(_selectedDrawerIndex),

    );
  }
}