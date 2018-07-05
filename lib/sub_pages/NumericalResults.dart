import 'package:flutter/material.dart';


///TODO: add results as they come in from the chemical sensor to be stored
///Implementation will be in a listview and allow user to select from the list
///what speicifc reading they would like to view
///Once user has selected result they can choose to export from there/ do data
///analysis etc.?
///
/// Maybe make it so like it will list the name of it (chemical, person, date)
/// and then show 3 icons for export, data analysis, view graphs
/// idea is to add a new variable for each entry
class Numerical extends StatelessWidget {
  //Learn to dynamically add generated widgets to this.
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView(
        children: <Widget>[
          entryOne,
          entryTwo,
          entryThree
        ],
    );
  }

  //add new widget for every test (eventually per user)
  Widget entryOne = ListTile(
    leading: Icon(Icons.donut_small),
    title: Text('Glucose,Kosik,080920'),
    subtitle: Text('Tap to view data'),
    onTap: (){

    },
  );

  Widget entryTwo = ListTile(
    leading: Icon(Icons.access_alarm),
    title: Text('Nad,Kosik,080921'),
    subtitle: Text('Tap to view data'),
    onTap: (){

    },
  );

  Widget entryThree = ListTile(
    leading: Icon(Icons.healing),
    title: Text('Sulfuric Acid,Kosik,080921'),
    subtitle: Text('Tap to view data'),
    onTap: (){

    },
  );

}