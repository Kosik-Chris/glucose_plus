import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:glucose_plus/main_pages/home_page.dart';
import 'package:glucose_plus/sub_pages/ChartResults.dart';
import 'package:glucose_plus/sub_pages/NewReading.dart';
import 'package:glucose_plus/sub_pages/ChemicalConfig.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
   int _selectedDrawerIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
/*    return new Center(
      child: new Text("Welcome home"),
    );*/

//FOR NOW ALL PICS JUST DROPPED INTO HERE
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
            decoration: BoxDecoration(color: Colors.cyan),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage("sensor_pic.jpg"),
              ),
              titleSection,
              scndSection
            ],
          )
        ],
      ),
    ),
  );
  }

  Widget titleSection = Container(
    padding: const EdgeInsets.all(32.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Glucose+ information and usability:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white
                  ),
                ),
              ),
              Text(
                'Glucose+ functions in tandem with the Glucose+ chemical sensor'
                    'device, based off Texas instruments LMP 15000. Ensure the '
                    'device is nearby and utilize either the sidebar tabs or'
                    'bellow buttons to access features.',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget scndSection = Container(
    padding: const EdgeInsets.all(32.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Glucose+ V0.3a',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    color: Colors.white
                  ),
                ),
              ),
              Text(
                'Information here.',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static Column buildButtonColumn(IconData icon, String label) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
/*          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),*/
            child: RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: null,
              child: new Text(label),

            )
        ),
      ],
    );
  }

  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        buildButtonColumn(Icons.track_changes, 'New Reading'),
        buildButtonColumn(Icons.local_bar, 'Chemical Config'),
        buildButtonColumn(Icons.insert_chart, 'Chart Results'),
      ],
    ),
  );

}