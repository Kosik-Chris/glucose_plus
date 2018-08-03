import 'package:flutter/material.dart';
import 'package:glucose_plus/main_pages/Details.dart';


class ChemConfigDialogue extends StatefulWidget {

  final Details details;

  ChemConfigDialogue({Key key, this.details}) : super(key: key);

  @override
  ChemConfigDialogueState createState() => new ChemConfigDialogueState();
}


class ChemConfigDialogueState extends State<ChemConfigDialogue>{
  int _bottomNavBarIndex = 0;
  bool autoCalibrateBool = true;
  bool biasSignBool = true;
  bool modeBool = true;




//each item is listed and provides options based on whats available
  //reference is editable?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.cyanAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: new InputDecoration(labelText: "Current amount"),
                keyboardType: TextInputType.number,
              ),
              Switch(
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                value: autoCalibrateBool,
                onChanged: (bool value){
                  setState(() {
                    //TODO: Create decoder for bool to string
                    autoCalibrateBool = value;
                  });
                },
              ),
              Switch(
                activeColor: Colors.red,
                inactiveThumbColor: Colors.black,
                value: biasSignBool,
                onChanged: (bool value){
                  setState(() {
                    //TODO: Create decoder for bool to string
                    biasSignBool = value;
                  });
                },
              ),
              AlertDialog(
                title: new Text("Bias Voltage Selection"),
                content: SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      //TODO: Implement on press functionality with decoder
                      new Text("V-Bias: 0%"),
                      new Text("V-Bias: 1%"),
                      new Text("V-Bias: 2%"),
                      new Text("V-Bias: 4%"),
                      new Text("V-Bias: 6%"),
                      new Text("V-Bias: 8%"),
                      new Text("V-Bias: 10%"),
                      new Text("V-Bias: 12%"),
                      new Text("V-Bias: 14%"),
                      new Text("V-Bias: 16%"),
                      new Text("V-Bias: 18%"),
                      new Text("V-Bias: 20%"),
                      new Text("V-Bias: 22%"),
                      new Text("V-Bias: 24%"),
                    ],
                  ),
                ),
              ),
              AlertDialog(
                title: new Text("Concentration selection"),
                content: SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      //TODO: Implement on press functionality with decoder
                      new Text("Concentration: Deca Molar"),
                      new Text("Concentration: Molar"),
                      new Text("Concentration: Deci Molar"),
                      new Text("Concentration: Centi Molar"),
                      new Text("Concentration: Milli Molar"),
                      new Text("Concentration: Micro Molar"),
                      new Text("Concentration: Nano Molar"),
                      new Text("Concentration: Pico Molar"),
                    ],
                  ),
                ),
              ),
              TextField(
                //min is 1 max is 1000
                //TODO: implement check for min and max and decoder
                decoration: new InputDecoration(labelText:
                "Sampling period in milli seconds"),
                keyboardType: TextInputType.number,
              ),
              AlertDialog(
                title: new Text("Gain Adjustment"),
                content: SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      //TODO: Implement on press functionality with decoder
                      new Text("Gain: 2.75k"),
                      new Text("Gain: 3.5k"),
                      new Text("Gain: 7k"),
                      new Text("Gain: 14k"),
                      new Text("Gain: 35k"),
                      new Text("Gain: 120k"),
                      new Text("Gain: 350k"),
                    ],
                  ),
                ),
              ),
              AlertDialog(
                title: new Text("Load Resistor"),
                content: SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      //TODO: Implement on press functionality with decoder
                      new Text("Load: 10"),
                      new Text("Load: 33"),
                      new Text("Load: 55"),
                      new Text("Load: 100"),
                    ],
                  ),
                ),
              ),
              Switch(
                activeColor: Colors.blueAccent,
                inactiveThumbColor: Colors.yellow,
                value: modeBool,
                onChanged: (bool value){
                  setState(() {
                    //TODO: Create decoder for bool to string
                    modeBool = value;
                  });
                },
              ),
              Text("refSource temp"),
              TextField(
                decoration: InputDecoration(labelText: "Current title: "
                    "${widget.details.title}"),
                keyboardType: TextInputType.number,
              ),
            ],
          )
        ],

      ),
    bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavBarIndex,
        onTap: (int index){
          if(index == 0){
            //popup window showing selection for frequency graphs
                  Navigator.pop(context);
          }
          if(index == 1){
            //popup window showing selection for time graphs
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

    )

    );
  }
}

