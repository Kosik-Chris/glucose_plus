import 'package:flutter/material.dart';

class TimeGraphDialog extends StatefulWidget {
  @override
  TimeGraphDialogState createState() => new TimeGraphDialogState();
}

class TimeGraphDialogState extends State<TimeGraphDialog> {

  int timeGraphSelection = 0;

  int graphSelection(){

    return timeGraphSelection;
  }

  @override
  Widget build(BuildContext context) {
      return new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.cyan,
            title: const Text('Time Graphs', style: TextStyle(color: Colors.white),),
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
                  Text("Current vs. Time",style: TextStyle(fontWeight:
                  FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
                  GestureDetector(
                    onTap: (){
                      timeGraphSelection = 3;
                      Navigator.pop(context);
                    },
                  child: Image(image: AssetImage("current_vs_time.png"))),
                  Text("Impedance vs. Time", style: TextStyle(fontWeight:
                  FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
                  GestureDetector(
                    onTap: (){
                      timeGraphSelection = 4;
                      Navigator.pop(context);
                    },
                  child: Image(image: AssetImage("impedance_vs_time.png")))
                ],
              )
            ],
          )
      );
  }
}