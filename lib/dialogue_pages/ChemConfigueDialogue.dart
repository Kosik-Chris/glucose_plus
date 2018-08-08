import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucose_plus/Firebase/Details.dart';
import 'dart:async';

import 'package:glucose_plus/main_pages/home_page.dart';


class ChemConfigDialogue extends StatefulWidget {

  final Details details;

  ChemConfigDialogue({Key key, this.details}) : super(key: key);

  @override
  ChemConfigDialogueState createState() => new ChemConfigDialogueState();
}


class ChemConfigDialogueState extends State<ChemConfigDialogue>{
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final chemicalController = TextEditingController();
  final samplePeriodController = TextEditingController();
  final concentrationController = TextEditingController();

  int _bottomNavBarIndex = 0;
  bool autoCalibrateBool = true;
  bool biasSignBool = true;
  bool modeBool = true;
  String autoCalibrate,biasSign,biasVoltage,samplingPeriod,gainAdjustment,
      mode,refSource,title, graphType, amount, loadResistor, concentration;
  DocumentSnapshot documentSent;

  //Define values that will be set temporarily to construct new Details to be
  //updated into firebase cloud
  //Worried that having 2 seperate firebases instances can hurt? will try to
  //Just implement in this class so it can handle it all
  String titleDetail;
  int amountDetail;
  String autoCalibrateDetail;
  String biasSignDetail;
  String biasVoltageDetail;
  int loadResistorDetail;
  String chemicalDetail;
  String concentrationDetail;
  String currTimeSamplePeriodDetail;
  String gainDetail;
  String graphTypeDetail;
  String modeDetail;
  String refSourceDetail;
  String voltCurrSamplePeriodDetail;

//  @override
//  void initState() {
//    super.initState();
//    //Changed to 3 for testing purposes
//    Timer(Duration(seconds: 3), ()=> Navigator.push(context,
//      MaterialPageRoute(builder: (context) => HomePage()),
//    ));
//  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titleController.dispose();

    super.dispose();
  }
  

  Widget _bottomNavBar(BuildContext context, DocumentSnapshot documentSent){
    this.documentSent = documentSent;
    return new BottomNavigationBar(
        currentIndex: _bottomNavBarIndex,
        onTap: (int index){
          //SAVE VALUES BUTTON
          if(index == 0){
            //Update firebase
            Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap =
        await transaction.get(documentSent.reference);
        await transaction.update(
            freshSnap.reference, {'reference': freshSnap['reference'] + 1,
            'title' : freshSnap[titleDetail],

        });
      });

          }
          //DISCARD BUTTON
          if(index == 1){
            //Exit and do nothing
            Navigator.pop(context);
          }
          setState(() {
            _bottomNavBarIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.save),
            title: Text('Save Values'),

          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.exit_to_app),
            title: Text('Exit Settings'),
          ),
        ]

    );
  }


//each item is listed and provides options based on whats available
  //reference is editable?
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('Chemicals').snapshots(),
        builder: (context, snapshot) {
      home: new Scaffold(

          body: new ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.cyanAccent),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new ListTile(
                    title: new Text("Title"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleTitleEdits),
                  ),
                  new ListTile(
                    title: new Text("Amount"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleAmountEdits),
                  ),
                  new ListTile(
                    title: new Text("Auto-Calibrate"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleAutoCalibrateEdits),
                  ),
                  new ListTile(
                    title: new Text("Bias Sign"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleBiasSignEdits),
                  ),
                  new ListTile(
                    title: new Text("Bias Voltage"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleBiasVoltageEdits),
                  ),
                  new ListTile(
                    title: new Text("Chemical"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleChemicalEdits),
                  ),
                  new ListTile(
                    title: new Text("Concentration"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleConcentrationEdits),
                  ),
                  new ListTile(
                    //This sampling period is common to both sampling methods
                    title: new Text("Sampling Period"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleSamplingPeriodEdits),
                  ),
                  new ListTile(
                    title: new Text("Gain Adjustment"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleGainEdits),
                  ),
                  new ListTile(
                    title: new Text("Graph Type"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),

                        onPressed: _handleGraphEdits),
                  ),
                  new ListTile(
                    title: new Text("Load Resistor"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleLoadResistorEdits),
                  ),
                  new ListTile(
                    title: new Text("Mode"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleModeEdits),
                  ),
                  new ListTile(
                    title: new Text("Reference Source"),
                    trailing: new RaisedButton(
                        child: new Text("Edit"),
                        onPressed: _handleReferenceSourceEdits),
                  ),
                ],

              )
            ],

          ),
        bottomNavigationBar: _bottomNavBar(context, snapshot.data.documents),

    );
  }
    );
  }



//Created separate method for each to simplify and handle conversions

  //*******************HANDLE METHODS***********************
  void _handleTitleEdits() {
    showDialog(context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         content: new TextField(
           controller: titleController,
           decoration: InputDecoration(
               labelText: 'Enter New Title'
           ),
         ),
         actions: <Widget>[
           new FlatButton(onPressed: () {
             //set the title detail value
             setTitleDetail(titleController.text);
             Navigator.pop(context);
           }, child: Text("Confirm")),
           new FlatButton(onPressed: () {
             Navigator.pop(context);
           }, child: Text("Cancel"))
         ],

       );
     }
      );

  }
  void _handleAmountEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextField(
              controller: amountController,
              decoration: InputDecoration(
                  labelText: 'Enter New Amount'
              ),
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                //set the title detail value
                setAmountDetail(amountController.text);
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleAutoCalibrateEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
//            contentPadding: new EdgeInsets.all(40.0),
            content: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                new RaisedButton(onPressed: (){
                  setAutoCalibrateDetail("On");
                },
                child: new Text("On"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setAutoCalibrateDetail("Off");
                },
                child: new Text("Off"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleBiasSignEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[

                new RaisedButton(onPressed: (){
                  setBiasSignDetail("Positive");
                },
                  child: new Text("Positive"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setBiasSignDetail("Negative");
                },
                  child: new Text("Negative"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleBiasVoltageEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new ListView(
              children: <Widget>[
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("0%");
                },
                  child: new Text("0%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("1%");
                },
                  child: new Text("1%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("2%");
                },
                  child: new Text("2%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("4%");
                },
                  child: new Text("4%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("6%");
                },
                  child: new Text("6%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("8%");
                },
                  child: new Text("8%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("10%");
                },
                  child: new Text("10%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("12%");
                },
                  child: new Text("12%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("14%");
                },
                  child: new Text("14%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("16%");
                },
                  child: new Text("16%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("18%");
                },
                  child: new Text("18%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("20%");
                },
                  child: new Text("20%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("22%");
                },
                  child: new Text("22%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("24%");
                },
                  child: new Text("24%"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleConcentrationEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextField(
              controller: concentrationController,
              decoration: InputDecoration(
                  labelText: 'Enter Concentration'
              ),
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                //set the title detail value
                setConcentrationDetail(concentrationController.text);
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleChemicalEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextField(
              controller: chemicalController,
              decoration: InputDecoration(
                  labelText: 'Enter Chemical'
              ),
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                //set the title detail value
                setChemicalDetail(chemicalController.text);
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleSamplingPeriodEdits(){
    //TODO: HANDLE that it needs to be in range of 1-1000
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextField(
              controller: samplePeriodController,
              decoration: InputDecoration(
                  labelText: 'Enter value from 1-1000 (milliseconds)'
              ),
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                //set the title detail value
                setCurrTimeSamplePeriodDetail(samplePeriodController.text);
                setVoltCurrSamplePeriodDetail(samplePeriodController.text);
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleGainEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new ListView(
              padding: EdgeInsets.only(bottom: 20.0),
              children: <Widget>[
                new RaisedButton(onPressed: (){
                  setGainDetail("2.75k");
                },
                  child: new Text("2.75k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("3.5k");
                },
                  child: new Text("3.5k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("7k");
                },
                  child: new Text("7k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("14k");
                },
                  child: new Text("14k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("35k");
                },
                  child: new Text("35k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("120k");
                },
                child: new Text("120k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("350k");
                },
                child: new Text("350k"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleGraphEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new ListView(
              children: <Widget>[
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("curr_v_time");
                },
                  child: new Text("Current vs. Time"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("curr_v_frequency");
                },
                  child: new Text("Current vs. Frequency"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("imp_v_freqy");
                },
                child: new Text("Impedance vs. Frequency"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("imp_v_time");
                },
                child: new Text("Impedance vs. Time"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("curr_v_volt");
                },
                child: new Text("Current vs. Voltage"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleLoadResistorEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new ListView(
              children: <Widget>[
                new RaisedButton(onPressed: (){
                  setLoadResistorDetail("10");
                },
                  child: new Text("10"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setRefSourceDetail("33");
                },
                  child: new Text("33"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setRefSourceDetail("50");
                },
                  child: new Text("50"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setRefSourceDetail("100");
                },
                  child: new Text("100"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleModeEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new RaisedButton(onPressed: (){
                  setModeDetail("3-Pronged");
                },
                  child: new Text("3-Pronged"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setModeDetail("2-Pronged");
                },
                  child: new Text("2-Pronged"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }
  void _handleReferenceSourceEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new RaisedButton(onPressed: (){
                  setRefSourceDetail("Internal");
                },
                  child: new Text("Internal"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setRefSourceDetail("External");
                },
                  child: new Text("External"),)
              ],
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Confirm")),
              new FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],

          );
        }
    );
  }


  //************SETTERS********************
  //Called when someone confirms an entry
  void setTitleDetail(String title){
    this.titleDetail = title;
  }
  void setAmountDetail(String amount){
    try {
      this.amountDetail = int.parse(amount);
    }catch(Exception){
      print("parse Error");
    }
  }
  void setLoadResistorDetail(String loadResistor){
    try{
      this.loadResistorDetail = int.parse(loadResistor);
    }catch(Exception){
      print("parse Error");
    }
  }
  void setAutoCalibrateDetail(String autoCalibrate){
    this.autoCalibrateDetail = autoCalibrate;
  }
  void setBiasSignDetail(String biasSign){
    this.biasSignDetail = biasSign;
  }
  void setBiasVoltageDetail(String biasVoltage){
    this.biasVoltageDetail = biasVoltage;
  }
  void setChemicalDetail(String chemical){
    this.chemicalDetail = chemical;
  }
  void setConcentrationDetail(String concentration){
    this.concentrationDetail = concentration;
  }
  void setCurrTimeSamplePeriodDetail(String currTimeSamplePeriod){
    this.currTimeSamplePeriodDetail = currTimeSamplePeriod;
  }
  void setGainDetail(String gain){
    this.gainDetail = gain;
  }
  void setGraphTypeDetail(String graphType){
    this.graphTypeDetail = graphType;
  }
  void setModeDetail(String mode){
    this.modeDetail = mode;
  }
  void setRefSourceDetail(String refSource){
    this.refSourceDetail = refSource;
  }
  void setVoltCurrSamplePeriodDetail(String voltCurrSamplePeriod){
    this.voltCurrSamplePeriodDetail = voltCurrSamplePeriod;
  }



//Maybe need but probably not
//Details constructDetails(int amount, int loadResistor, int reference,
//    String title, String autoCalibrate, String biasSign, String biasVoltage,
//    String chemical, String concentration, String currTimeSamplePeriod,
//    String gain, String graphType, String mode, String refSource, String
//    voltCurrSamplePeriod){
//
//    return null;
//}




}


