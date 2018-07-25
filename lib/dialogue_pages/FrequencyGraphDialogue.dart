import 'package:flutter/material.dart';

class FrequencyGraphDialog extends StatefulWidget {
  @override
  FrequencyGraphDialogState createState() => new FrequencyGraphDialogState();
}

class FrequencyGraphDialogState extends State<FrequencyGraphDialog> {
  int frequencyGraphSelection = 0;

  String getSnackBarMsg(){
    //TODO dynamic loaded Snackbar message
    String message;
    if(frequencyGraphSelection == 1){
      message = "Current vs. Frequency";
    }
    if(frequencyGraphSelection == 2){
      message = "Impedance vs. Frequency";
    }
    return message;
  }

  int graphSelection(){

    return frequencyGraphSelection;
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Frequency Graphs', style: TextStyle(color: Colors.white),),
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
              Text("Current vs. Frequency",style: TextStyle(fontWeight:
                  FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
              GestureDetector(
                  onTap: (){
                    frequencyGraphSelection = 1;
//                    SnackBar(content: Text("Current vs. Frequency Loaded"));
                    Navigator.pop(context);
                  },
                  child: Image(image: AssetImage("current_vs_frequency.png")),),
              Text("Impedance vs. Frequency", style: TextStyle(fontWeight:
              FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
              GestureDetector(
                  onTap: (){
                    frequencyGraphSelection = 2;
//                    final snack = SnackBar(content: Text("Impedance vs. Frequency Loaded"));
//                    Scaffold.of(context).showSnackBar(snack);
                    Navigator.pop(context);
                  },
                  child: Image(image: AssetImage("impedance_vs_frequency.png")))
            ],
          )
        ],
      )
    );
  }
}

//TODO: Experiment more with Snackbar temp disabled.
//class ImpedanceSnack extends StatelessWidget{
//  @override
//  Widget build(BuildContext context) {
//    // Our GestureDetector wraps our button
//    return GestureDetector(
//      onTap: (){
//        SnackBar(content: Text("Current vs. Frequency Loaded"));
//        Navigator.pop(context);
//      },
//      child: Image(image: AssetImage("current_vs_frequency.png")),);
//  }
//
//}


