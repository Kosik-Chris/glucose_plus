import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:path/path.dart';
import 'package:glucose_plus/sub_pages/BluetoothConfig.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:glucose_plus/record_pages/units.dart';


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

    Chemicals _selectedChemical;
    Units _selectedUnit;
    int _bottomNavBarIndex = 0;

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ButtonBar(

                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new DropdownButton<Chemicals>(
                        hint: new Text("Select Chemical"),
                        value: _selectedChemical,

                        items: ChemicalsValues.map((Chemicals chemical) {
                          return new DropdownMenuItem<Chemicals>(
                            value: chemical,
                            child: new Text(chemical.title,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        ).toList(),
                        onChanged: (Chemicals newChem) {
                          setState(() {
                            _selectedChemical = newChem;
                          });

                        }
                    ),
                    new DropdownButton<Units>(
                        hint: new Text("Select Concentration"),
                        value: _selectedUnit,

                        items: MetricUnits.map((Units unit) {
                          return new DropdownMenuItem<Units>(
                            value: unit,
                            child: new Text(unit.title,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        ).toList(),
                        onChanged: (Units newUnit) {
                          setState(() {
                            _selectedUnit = newUnit;
                          });
                        }
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(

            backgroundColor: const Color(0xFF0099ed),
            child: Icon(Icons.track_changes),
            onPressed: (){
//            checkBlueTooth();
//            sendChemSelect();
//            receiveValues();
//            buildOutput();

              //User can select whether to save, send, discard.
              //Add other features later.
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewResults()));
            }

        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavBarIndex,
            onTap: (int index){
              if(index == 0){
                //save image

              }
              if(index == 1){
                //discard image and return home

              }
              if(index == 2){
                //save image and open up email with image attached

              }
              setState(() {
                _bottomNavBarIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.save),
                title: Text('Voltammetry'),

              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.transfer_within_a_station),
                title: Text('Ammetry'),
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.exit_to_app),
                title: Text('Other'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.exit_to_app),
                title: Text('Other'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.exit_to_app),
                title: Text('Other'),
              )
            ]

        ),
      )
          );
    }



    checkBlueTooth(){
    //TODO GIT GUD at BLE
      if(isConnected == true){
        //proceed
      }
      else{


      }
  }
  sendChemSelect(){
      //TODO PASS SELECTION VALUES
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