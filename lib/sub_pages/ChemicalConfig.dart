import 'package:flutter/material.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';


class ChemicalsMain extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new ChemicalsMainState();
  }
}

class ChemicalsMainState extends State<ChemicalsMain> {

  Chemicals selectedChemical;
  String configMsg = "HOLDER";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color(0xFF229E9C),
      ),
      home: new Scaffold(
        body: new Container(
          child: new ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.cyanAccent),
              ),
              new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Row(
                  children: <Widget>[

                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.all(16.0),
                child:
                new DropdownButton<Chemicals>(
                  hint: new Text("Select a Chemical"),
                  value: selectedChemical,

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
                      selectedChemical = newChem;
                    });

                  }
                ),
              ),
              new Container(
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: (){
                        _chemConfig();
                      },
                      child: new Text('Configure'),
                    ),
                    new Text(configMsg)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Make sure all methods that call setState() are within Main state class
  _chemConfig(){
    //Upon selection of chemical this method configures settings and
    //then calls another method to send the data configurations to MCU
    try {
      for (int i; i < ChemicalsValues.length; i++) {
        if (selectedChemical == ChemicalsValues[i]) {
          configMsg = 'Configuring' + ChemicalsValues[i].toString();
        }
      }
    }catch(e){
      print(e.toString());
    }

  }


}

