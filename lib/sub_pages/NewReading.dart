import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:path/path.dart';
import 'package:fcharts/fcharts.dart';
import 'package:flutter_blue/flutter_blue.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
//temp chart data
const data = [[1.0,0.0], [2.0,-0.2], [3.0,-0.9], [4.0,-0.5], [5.0,0.0], [6.0,0.5],
[7.0,0.6], [8.0,0.9], [9.0,0.8], [10.0,1.2], [11.0,0.5], [12.0,0.0]];

class NewReading extends StatefulWidget {

  NewReading({Key key, this.title}) : super(key: key);
  final String title;

  State<StatefulWidget> createState() {
    return new NewReadingMainState();
  }
}

  class NewReadingMainState extends State<NewReading> {
    FlutterBlue _flutterBlue = FlutterBlue.instance;

    /// State
    StreamSubscription _stateSubscription;
    BluetoothState state = BluetoothState.unknown;

    /// Scanning
    StreamSubscription _scanSubscription;
    Map<DeviceIdentifier, ScanResult> scanResults = new Map();
    bool isScanning = false;

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
      deviceConnection?.cancel();
      deviceConnection = null;
      super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primaryColor: const Color(0xFF229E9C),
        ),
        title: 'Branch Setup',
    home: new Scaffold(
      body: new Container(
     child: new Row(
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

            ),
          ],

      ),
      ),

      floatingActionButton: new FloatingActionButton(
          backgroundColor: const Color(0xFF0099ed),
          child: new Icon(Icons.track_changes),
          onPressed: (){
            checkBlueTooth();
            sendChemSelect();
            receiveValues();
            buildOutput();
            //User can select whether to save, send, discard.
            //Add other features later.
//            Navigator.push(
//            context, MaterialPageRoute(builder: (context) => NewResults()));
          }

      ),
    ),
    );
  }

  checkBlueTooth(){

      if(isConnected == true){
        //proceed
      }
      else{
        //Bring up window to connect to bluetooth device

      }
  }
  sendChemSelect(){
    //check if using selected chemical or sending custom setting values
    //check to make sure if ok
    //send values to MCU
    //prime MCU for new chemical reading

  }
  receiveValues(){
    //receive packet, check for what type of reading is being sent
    //loops around looking for the end of the transmit request, recording all sent
    //store values in arraylist etc.
  }
  buildOutput(){
    //build graph output on this activity or new Results activity
    //take stored values and generate an excel/ csv file of received values
  }

}