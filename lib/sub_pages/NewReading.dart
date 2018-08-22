import 'dart:async';
import 'package:glucose_plus/sub_pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/NewReadingResult.dart';
import 'package:path/path.dart';
import 'package:glucose_plus/Connection/Bluetooth_Middleware/BluetoothController.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:glucose_plus/record_pages/units.dart';
import 'package:glucose_plus/dialogue_pages/FrequencyGraphDialog.dart';
import 'package:glucose_plus/dialogue_pages/OtherGraphDialog.dart';
import 'package:glucose_plus/dialogue_pages/TimeGraphDialog.dart';


class NewReading extends StatefulWidget {

  final BluetoothControl blueControl;
  NewReading( this.blueControl);


  State<StatefulWidget> createState() {
    return new NewReadingMainState(blueControl);
  }
}

  class NewReadingMainState extends State<NewReading> {

  BluetoothControl blueControl;
    NewReadingMainState(
        this.blueControl
        );

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


    @override
    void initState() {
      super.initState();


      // Immediately get the state of FlutterBlue
      blueControl.flutterBlue.state.then((s) {
        setState(() {
          blueControl.state = s;
        });
      });
      // Subscribe to state changes
      blueControl.stateSubscription = blueControl.flutterBlue.onStateChanged().listen((s) {
        setState(() {
          blueControl.state = s;
        });
      });
    }

    @override
    void dispose() {
      blueControl.stateSubscription?.cancel();
      blueControl.stateSubscription = null;
      blueControl.scanSubscription?.cancel();
      blueControl.scanSubscription = null;
//      deviceConnection?.cancel();
//      deviceConnection = null;
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
        resizeToAvoidBottomPadding: false,
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
                  keyboardType: TextInputType.number,
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
            checkBlueTooth(context);
//            sendChemSelect();
//            receiveValues();
//            buildOutput();

              //User can select whether to save, send, discard.
              //Add other features later.
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
//
//    Future _openFrequencyDialogue() async{
//
//    }
//
//    Future _openTimeDialogue() async{
//
//    }
//
//    Future _openOtherDialogue() async{
//
//    }



    checkBlueTooth(BuildContext context){
      if(blueControl.isConnected == true){
        //proceed
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoadingPage()));
      }
      else{
          return;
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