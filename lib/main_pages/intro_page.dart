import 'package:flutter/material.dart';
import 'home_page.dart';
import 'dart:async';

class IntroPage extends StatefulWidget{

  @override
  IntroPageState createState() => new IntroPageState();
}

class IntroPageState extends State<IntroPage>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), ()=> Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage()),
              ));
  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.cyan),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100.0,
                      child: Container(
                        child: new Image.asset(
                          'sensor_pic.jpg'
                        ),
                      )

                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0),),
                    Text(
                      "Glucose+",style: TextStyle(color: Colors.white,
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "version 1.0.0.0"
                    ),
                  ],
                ),
              ),
              Expanded(flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LinearProgressIndicator(),
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  Text("Smaller sensors for larger results",
                  style: TextStyle(color: Colors.white,fontSize: 18.0,
                      fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                ],
              ),
              )
            ],
          )
        ],
      ),
    );
  }
}
