import 'dart:async';
import 'package:glucose_plus/sub_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:path/path.dart';
import 'package:glucose_plus/sub_pages/BluetoothConfig.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:glucose_plus/record_pages/units.dart';
import 'package:glucose_plus/dialogue_pages/FrequencyGraphDialogue.dart';
import 'package:glucose_plus/dialogue_pages/OtherGraphDialogue.dart';
import 'package:glucose_plus/dialogue_pages/TimeGraphDialogue.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

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
    String selectedGraph = "current_vs_time.png";



    String selectedGraphDisplay(){
      int selectedGraphNum = 0;

      FrequencyGraphDialogState f = new FrequencyGraphDialogState();
      OtherGraphDialogState o = new OtherGraphDialogState();
      TimeGraphDialogState t = new TimeGraphDialogState();

      int frequencyHolder = f.graphSelection();
      int otherHolder = o.graphSelection();
      int timeHolder = t.graphSelection();

      if(frequencyHolder>0){
        selectedGraphNum = frequencyHolder;
      }
      if(otherHolder>0){
        selectedGraphNum = otherHolder;
      }
      if(timeHolder>0){
        selectedGraphNum = timeHolder;
      }

      if(selectedGraphNum == 0){
        setState(() {
          selectedGraph = "current_vs_time.png";
        });
      }
      if(selectedGraphNum == 1){
        setState(() {
          selectedGraph = "current_vs_frequency.png";
        });
      }
      if(selectedGraphNum == 2){
        setState(() {
          selectedGraph = "impedance_vs_frequency.png";
        });
      }
      if(selectedGraphNum == 3){
        setState(() {
          selectedGraph = "current_vs_time.png";
        });
      }
      if(selectedGraphNum ==4){
        setState(() {
          selectedGraph = "impedance_vs_time.png";
        });
      }
      if(selectedGraphNum == 5){
        setState(() {
          selectedGraph = "current_vs_voltage.png";
        });
      }

      return selectedGraph;
    }

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
                Text(
                  "Enter Quantity:", textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 24.0),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter quantity of chemical'
                  )),
                //Add image depending on bottom navbar selection
                Text("Selected Graph",style: TextStyle(fontWeight:
                    FontWeight.bold, fontSize: 30.0), textAlign: TextAlign.center,),
                Image( image: AssetImage(selectedGraphDisplay()),

                ),
                Text("Fill all fields out then select blue button to proceed",
                textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),)
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
                  context, MaterialPageRoute(builder: (context) => LoadingPage()));
            }

        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavBarIndex,
            onTap: (int index){
              if(index == 0){
                //popup window showing selection for frequency graphs
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context){
                      return new FrequencyGraphDialog();
                    },
                    fullscreenDialog: true
                ));

              }
              if(index == 1){
                //popup window showing selection for time graphs
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context){
                    return new TimeGraphDialog();
                  },
                    fullscreenDialog: true
                ));

              }
              if(index == 2){
                //popup window showing selection for other graphs
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context){
                    return new OtherGraphDialog();
                  },
                    fullscreenDialog: true
                ));
              }
              setState(() {
                _bottomNavBarIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.multiline_chart),
                title: Text('Frequency Graphs'),

              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.show_chart),
                title: Text('Time Graphs'),
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.bubble_chart),
                title: Text('Other Graphs'),
              )
            ]

        ),
      )
          );
    }

    Future _openFrequencyDialogue() async{

    }

    Future _openTimeDialogue() async{

    }

    Future _openOtherDialogue() async{

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