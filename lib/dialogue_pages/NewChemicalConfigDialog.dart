import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glucose_plus/sub_pages/ChemicalConfig.dart';
import 'package:glucose_plus/Connection/ChemicalsFire.dart';

class NewChemConfigDialogue extends StatefulWidget {

  @override
  NewChemConfigDialogueState createState() => new NewChemConfigDialogueState();
}


class NewChemConfigDialogueState extends State<NewChemConfigDialogue>{

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final chemicalController = TextEditingController();
  final samplePeriodController = TextEditingController();
  final concentrationController = TextEditingController();
  final concentrationUnitsController = TextEditingController();
  final amountUnitsController = TextEditingController();

  int _bottomNavBarIndex = 0;

  //Define values that will be set temporarily to construct new Details to be
  //updated into firebase cloud
  //Worried that having 2 seperate firebases instances can hurt? will try to
  //Just implement in this class so it can handle it all
  String _titleDetail = "Empty";
  String _amountDetail = "Empty";
  String _amountUnitsDetail = "Empty";
  String _autoCalibrateDetail = "Empty";
  String _biasSignDetail = "Empty";
  String _biasVoltageDetail = "Empty";
  String _loadResistorDetail = "Empty";
  String _chemicalDetail = "Empty";
  String _concentrationDetail = "Empty";
  String _currTimeSamplePeriodDetail = "Empty";
  String _gainDetail = "Empty";
  String _graphTypeDetail = "Empty";
  String _modeDetail = "Empty";
  String _refSourceDetail = "Empty";
  String _voltCurrSamplePeriodDetail = "Empty";
  String _concentrationUnitsDetail = "Empty";

  List<ChemicalsFire> chemicals = List();
  ChemicalsFire chemicalsFire;
  DatabaseReference chemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    chemicalsFire = ChemicalsFire("", "", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "","");
    chemRef = FirebaseDatabase.instance.reference().child('chemicals');
  }



  void handleSubmit(){
    final FormState form = formKey.currentState;

      chemicalsFire.title = _titleDetail;
      chemicalsFire.amount = _amountDetail;
      chemicalsFire.amountUnits = _amountUnitsDetail;
      chemicalsFire.chemical = _chemicalDetail;
      chemicalsFire.concentration = _concentrationDetail;
      chemicalsFire.concentrationUnits = _concentrationUnitsDetail;
      chemicalsFire.voltCurrSamplePeriod = _voltCurrSamplePeriodDetail;
      chemicalsFire.currTimeSamplePeriod = _currTimeSamplePeriodDetail;
      chemicalsFire.autoCalibrate = _autoCalibrateDetail;
      chemicalsFire.biasSign = _biasSignDetail;
      chemicalsFire.biasVoltage = _biasVoltageDetail;
      chemicalsFire.gain = _gainDetail;
      chemicalsFire.graphType = _graphTypeDetail;
      chemicalsFire.loadResistor = _loadResistorDetail;
      chemicalsFire.reference = "1";
      chemicalsFire.mode = _modeDetail;
      chemicalsFire.refSource = _refSourceDetail;
      chemRef.push().set(chemicalsFire.toJson());
  }

  Widget _bottomNavBar(BuildContext context){
    return new BottomNavigationBar(
        currentIndex: _bottomNavBarIndex,
        onTap: (int index){
          //SAVE VALUES BUTTON
          if(index == 0){
            handleSubmit();
            Navigator.pop(context);

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







  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:("Glucose+"),
          home: new Scaffold(

            body: new ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.cyanAccent),
                ),
                Form(
                  key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new ListTile(
                      title: new Text("Title"),
                      subtitle: new Text("Current Title: "+_titleDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleTitleEdits),

                    ),
                    new ListTile(
                      title: new Text("Amount"),
                      subtitle: new Text("Current amount: "+_amountDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleAmountEdits),
                    ),
                    new ListTile(
                      title: new Text("Amount Units"),
                      subtitle: new Text("Current Units: "+_amountUnitsDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleAmountUnitsEdits),
                    ),
                    new ListTile(
                      title: new Text("Auto-Calibrate"),
                      subtitle: new Text("Current Auto-calibrate: "+_autoCalibrateDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleAutoCalibrateEdits),
                    ),
                    new ListTile(
                      title: new Text("Bias Sign"),
                      subtitle: new Text("Current Bias Sign: "+_biasSignDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleBiasSignEdits),
                    ),
                    new ListTile(
                      title: new Text("Bias Voltage"),
                      subtitle: new Text("Current Bias Voltage: "+_biasVoltageDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleBiasVoltageEdits),
                    ),
                    new ListTile(
                      title: new Text("Chemical"),
                      subtitle: new Text("Current chemical: "+_chemicalDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleChemicalEdits),
                    ),
                    new ListTile(
                      title: new Text("Concentration"),
                      subtitle: new Text("Current Concentration: "+_concentrationDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleConcentrationEdits),
                    ),
                    new ListTile(
                      title: new Text("Concentration Units"),
                      subtitle: new Text("Current Concentration Units: "+_concentrationUnitsDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleConcentrationUnitsEdits),
                    ),
                    new ListTile(
                      //This sampling period is common to both sampling methods
                      title: new Text("Sampling Period"),
                      subtitle: new Text("Current SamplingPeriod: "+_voltCurrSamplePeriodDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleSamplingPeriodEdits),
                    ),
                    new ListTile(
                      title: new Text("Gain Adjustment"),
                      subtitle: new Text("Current Gain: "+_gainDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleGainEdits),
                    ),
                    new ListTile(
                      title: new Text("Graph Type"),
                      subtitle: new Text("Current Graph: "+_graphTypeDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),

                          onPressed: _handleGraphEdits),
                    ),
                    new ListTile(
                      title: new Text("Load Resistor"),
                      subtitle: new Text("Current Load Resistor: "+_loadResistorDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleLoadResistorEdits),
                    ),
                    new ListTile(
                      title: new Text("Mode"),
                      subtitle: new Text("Current mode: "+_modeDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleModeEdits),
                    ),
                    new ListTile(
                      title: new Text("Reference Source"),
                      subtitle: new Text("Current reference source: "+_refSourceDetail),
                      trailing: new RaisedButton(
                          child: new Text("Edit"),
                          onPressed: _handleReferenceSourceEdits),
                    ),
                  ],

                ),
                ),
              ],

            ),
            bottomNavigationBar: _bottomNavBar(context),

          ),
    );
        }


  //*******************HANDLE METHODS***********************
  void _handleTitleEdits() {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: 'Enter New Title'
              ),
              onSaved: (val) => chemicalsFire.title = val,
              validator: (val) => val == "" ? val : null,
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
            content: new TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                  labelText: 'Enter New Amount'
              ),
              keyboardType: TextInputType.number,
              onSaved: (val) => chemicalsFire.amount = val,
              validator: (val) => val == "" ? val : null,
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
  void _handleAmountUnitsEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextFormField(
              controller: amountUnitsController,
              decoration: InputDecoration(
                  labelText: 'Enter New Units'
              ),
              onSaved: (val) => chemicalsFire.amountUnits = val,
              validator: (val) => val == "" ? val : null,
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                //set the title detail value
                setAmountUnitsDetail(amountUnitsController.text);
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
                  Navigator.pop(context);
                },
                  child: new Text("On"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setAutoCalibrateDetail("Off");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                  child: new Text("Positive"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setBiasSignDetail("Negative");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                  child: new Text("0%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("1%");
                  Navigator.pop(context);
                },
                  child: new Text("1%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("2%");
                  Navigator.pop(context);
                },
                  child: new Text("2%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("4%");
                  Navigator.pop(context);
                },
                  child: new Text("4%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("6%");
                  Navigator.pop(context);
                },
                  child: new Text("6%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("8%");
                  Navigator.pop(context);
                },
                  child: new Text("8%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("10%");
                  Navigator.pop(context);
                },
                  child: new Text("10%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("12%");
                  Navigator.pop(context);
                },
                  child: new Text("12%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("14%");
                  Navigator.pop(context);
                },
                  child: new Text("14%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("16%");
                  Navigator.pop(context);
                },
                  child: new Text("16%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("18%");
                  Navigator.pop(context);
                },
                  child: new Text("18%"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setBiasVoltageDetail("20%");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
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
            content: new TextFormField(
              controller: concentrationController,
              decoration: InputDecoration(
                  labelText: 'Enter Concentration'
              ),
              keyboardType: TextInputType.number,
              onSaved: (val) => chemicalsFire.concentration = val,
              validator: (val) => val == "" ? val : null,
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
  void _handleConcentrationUnitsEdits(){
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new TextFormField(
              controller: concentrationUnitsController,
              decoration: InputDecoration(
                  labelText: 'Enter ConcentrationUnits'
              ),
              onSaved: (val) => chemicalsFire.concentrationUnits = val,
              validator: (val) => val == "" ? val : null,
            ),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                //set the title detail value
                setConcentrationUnitsDetail(concentrationUnitsController.text);
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
            content: new TextFormField(
              controller: chemicalController,
              decoration: InputDecoration(
                  labelText: 'Enter Chemical'
              ),
              onSaved: (val) => chemicalsFire.chemical = val,
              validator: (val) => val == "" ? val : null,
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
            content: new TextFormField(
              controller: samplePeriodController,
              decoration: InputDecoration(
                  labelText: 'Enter value from 1-1000 (milliseconds)'
              ),
              onSaved: (val) => chemicalsFire.amount = val,
              validator: (val) => val == "" ? val : null,
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
                  Navigator.pop(context);
                },
                  child: new Text("2.75k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("3.5k");
                  Navigator.pop(context);

                },
                  child: new Text("3.5k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("7k");
                  Navigator.pop(context);
                },
                  child: new Text("7k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("14k");
                  Navigator.pop(context);
                },
                  child: new Text("14k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("35k");
                  Navigator.pop(context);
                },
                  child: new Text("35k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("120k");
                  Navigator.pop(context);
                },
                  child: new Text("120k"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGainDetail("350k");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                  child: new Text("Current vs. Time"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("curr_v_frequency");
                  Navigator.pop(context);
                },
                  child: new Text("Current vs. Frequency"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("imp_v_freqy");
                  Navigator.pop(context);
                },
                  child: new Text("Impedance vs. Frequency"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("imp_v_time");
                  Navigator.pop(context);
                },
                  child: new Text("Impedance vs. Time"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setGraphTypeDetail("curr_v_volt");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                  child: new Text("10"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setLoadResistorDetail("33");
                  Navigator.pop(context);
                },
                  child: new Text("33"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setLoadResistorDetail("50");
                  Navigator.pop(context);
                },
                  child: new Text("50"),),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new RaisedButton(onPressed: (){
                  setLoadResistorDetail("100");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                  child: new Text("3-Pronged"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setModeDetail("2-Pronged");
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                  child: new Text("Internal"),),
                new Padding(padding: const EdgeInsets.only(right: 10.0)),
                new RaisedButton(onPressed: (){
                  setRefSourceDetail("External");
                  Navigator.pop(context);
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
    setState(() {
      this._titleDetail = title;
    });
  }
  void setAmountDetail(String amount){
    setState(() {
      try {
        this._amountDetail = (amount);
      }catch(Exception){
        print("parse Error");
      }
    });

  }
  void setAmountUnitsDetail(String amountUnits){
    setState(() {
      this._amountUnitsDetail = amountUnits;
    });
  }
  void setLoadResistorDetail(String loadResistor){
    setState(() {
      try{
        this._loadResistorDetail = (loadResistor);
      }catch(Exception){
        print("parse Error");
      }
    });
  }
  void setAutoCalibrateDetail(String autoCalibrate){
    setState(() {
      this._autoCalibrateDetail = autoCalibrate;
    });
  }
  void setBiasSignDetail(String biasSign){
    setState(() {
      this._biasSignDetail = biasSign;
    });
  }
  void setBiasVoltageDetail(String biasVoltage){
    setState(() {
      this._biasVoltageDetail = biasVoltage;
    });
  }
  void setChemicalDetail(String chemical){
    setState(() {
      this._chemicalDetail = chemical;
    });
  }
  void setConcentrationDetail(String concentration){
    setState(() {
      this._concentrationDetail = concentration;
    });
  }
  void setConcentrationUnitsDetail(String concentrationUnits){
    setState(() {
      this._concentrationUnitsDetail = concentrationUnits;
    });
  }
  void setCurrTimeSamplePeriodDetail(String currTimeSamplePeriod){
    setState(() {
      this._currTimeSamplePeriodDetail = currTimeSamplePeriod;
    });
  }
  void setGainDetail(String gain){
    setState(() {
      this._gainDetail = gain;
    });
  }
  void setGraphTypeDetail(String graphType){
    setState(() {
      this._graphTypeDetail = graphType;
    });
  }
  void setModeDetail(String mode){
    setState(() {
      this._modeDetail = mode;
    });
  }
  void setRefSourceDetail(String refSource){
    setState(() {
      this._refSourceDetail = refSource;
    });
  }
  void setVoltCurrSamplePeriodDetail(String voltCurrSamplePeriod){
    setState(() {
      this._voltCurrSamplePeriodDetail = voltCurrSamplePeriod;
    });
  }





  }


