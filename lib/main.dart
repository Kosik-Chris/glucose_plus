import 'package:glucose_plus/main_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sliver_calendar/sliver_calendar.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:math';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/main_pages/intro_page.dart';
import 'dart:typed_data';
import 'dart:async';

void main() async{
ByteData loadedData;



await Future.wait([
rootBundle.load('2018c.tzf').then((ByteData data) {
loadedData = data;
print('loaded data');
})
]);
initializeDatabase(loadedData.buffer.asUint8List());
runApp(new GlucosePlusApp());
}

class GlucosePlusApp extends StatelessWidget {
  // root widget
  //Initialize Bluetooth request here
  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      title: 'Glucose+',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        fontFamily: 'icomoon',
      ),
      home: new IntroPage(),

    );
  }
}