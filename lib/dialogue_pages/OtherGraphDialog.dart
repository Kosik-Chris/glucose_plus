import 'package:flutter/material.dart';

class OtherGraphDialog extends StatefulWidget {
  @override
  OtherGraphDialogState createState() => new OtherGraphDialogState();
}

class OtherGraphDialogState extends State<OtherGraphDialog> {

  int otherGraphSelection = 0;

  int graphSelection(){

    return otherGraphSelection;
  }


  @override
  Widget build(BuildContext context) {
      return new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.cyan,
            title: const Text('Other Graphs', style: TextStyle(color: Colors.white),),
            actions: [
              new FlatButton(
                  onPressed: () {
                    //TODO: Handle save - sets chart to view in New Reading
                  },
                  child: new Text('SAVE',
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Colors.white))),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.cyanAccent),
              ),
              new ListView(
                children: <Widget>[
                  Text("Current vs. Voltage",style: TextStyle(fontWeight:
                  FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
                  GestureDetector(
                    onTap: (){
                      otherGraphSelection = 5;
                      Navigator.pop(context);
                    },
                  child: Image(image: AssetImage("current_vs_voltage.png"))),
                ],
              )
            ],
          )
      );
  }
}