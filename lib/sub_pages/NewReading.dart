import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:path/path.dart';

class NewReading extends StatelessWidget {
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