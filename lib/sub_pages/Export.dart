import 'package:flutter/material.dart';
import 'package:mailer3/mailer3.dart';
import 'dart:io';
import 'package:glucose_plus/mailer.dart';

class Export extends StatefulWidget {

  State<StatefulWidget> createState() {

    return new ExportState();
  }
}

class ExportState extends State<Export>{




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.cyan,
      ),
      title: 'Glucose+',
      home: new Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.cyanAccent),
            ),
            Center(
              child: new Text("Account temp"),
            )
          ],
        ),
      ),
    );
  }

}