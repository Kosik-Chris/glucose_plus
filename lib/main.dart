import 'package:glucose_plus/main_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(new GlucosePlusApp());

class GlucosePlusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Glucose+',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: new HomePage(),
    );
  }
}