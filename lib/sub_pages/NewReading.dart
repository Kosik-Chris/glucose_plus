import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:path/path.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class NewReading extends StatelessWidget {
  final drawerItems = [
    new DrawerItem("Glucose+  Home", Icons.home),
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
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                      "Ensure Bluetooth connection is configured.",
                      style: new TextStyle(fontSize:18.0,
                          color: Colors.black,
                          fontFamily: "Roboto")
                  )
                ]

            )
          ]

      ),

      floatingActionButton: new FloatingActionButton(
          backgroundColor: const Color(0xFF0099ed),
          child: new Icon(Icons.track_changes),
          onPressed: (){
            Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewResults()));
          }

      ),
    );
  }


}