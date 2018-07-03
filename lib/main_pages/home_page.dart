import 'package:glucose_plus/sub_pages/Account.dart';
import 'package:glucose_plus/sub_pages/BluetoothConfig.dart';
import 'package:glucose_plus/sub_pages/ChemicalConfig.dart';
import 'package:glucose_plus/sub_pages/NumericalResults.dart';
import 'package:glucose_plus/sub_pages/ChartResults.dart';
import 'package:glucose_plus/sub_pages/Export.dart';
import 'package:glucose_plus/sub_pages/Biometrics.dart';
import 'package:glucose_plus/sub_pages/Hb1acCalc.dart';
import 'package:glucose_plus/sub_pages/NewReading.dart';
import 'package:glucose_plus/sub_pages/Home.dart';
import 'package:glucose_plus/sub_pages/send_email.dart';

import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Account", Icons.account_circle),
    new DrawerItem("Bluetooth configuration", Icons.settings_bluetooth),
    new DrawerItem("Chemical configuration", Icons.local_bar),
    new DrawerItem("New reading", Icons.track_changes),
    new DrawerItem("Numerical results", Icons.traffic),
    new DrawerItem("Chart results", Icons.insert_chart),
    new DrawerItem("Export", Icons.send),
    new DrawerItem("Biometrics", Icons.healing),
    new DrawerItem("Hb1Ac calculator",Icons.donut_small)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new Account();
      case 2:
        return new Bluetooth();
      case 3:
        return new Chemicals();
      case 4:
        return new NewReading();
      case 5:
        return new Numerical();
      case 6:
        return new Chart();
      case 7:
        return new Export();
      case 8:
        return new Biometrics();
      case 9:
        return new Hb1Calc();
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
    for (var i = 0; i < widget.drawerItems.length; i++) {
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
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}