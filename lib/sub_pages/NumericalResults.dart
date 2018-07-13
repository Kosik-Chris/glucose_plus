import 'package:flutter/material.dart';
import 'package:sliver_calendar/sliver_calendar.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';


///TODO: add results as they come in from the chemical sensor to be stored
///Implementation will be in a listview and allow user to select from the list
///what speicifc reading they would like to view
///Once user has selected result they can choose to export from there/ do data
///analysis etc.?
///
/// Maybe make it so like it will list the name of it (chemical, person, date)
/// and then show 3 icons for export, data analysis, view graphs
/// idea is to add a new variable for each entry
//class Numerical extends StatelessWidget {
//  //Learn to dynamically add generated widgets to this.
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new ListView(
//        children: <Widget>[
//          entryOne,
//          entryTwo,
//          entryThree
//        ],
//    );
//  }
//
//  //add new widget for every test (eventually per user)
//  Widget entryOne = ListTile(
//    leading: Icon(Icons.donut_small),
//    title: Text('Glucose,Kosik,080920'),
//    subtitle: Text('Tap to view data'),
//    onTap: (){
//
//    },
//  );
//
//  Widget entryTwo = ListTile(
//    leading: Icon(Icons.access_alarm),
//    title: Text('Nad,Kosik,080921'),
//    subtitle: Text('Tap to view data'),
//    onTap: (){
//
//    },
//  );
//
//  Widget entryThree = ListTile(
//    leading: Icon(Icons.healing),
//    title: Text('Sulfuric Acid,Kosik,080921'),
//    subtitle: Text('Tap to view data'),
//    onTap: (){
//
//    },
//  );
//
//}
class Numerical extends StatefulWidget{
  Numerical({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NumericalState createState() => new _NumericalState();
}

class _NumericalState extends State<Numerical>{
  CalendarSource source;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          new FutureBuilder(
            future: FlutterNativeTimezone.getLocalTimezone(),
            builder: (BuildContext context, AsyncSnapshot<String> tz) {
              if (tz.hasData) {
                Location loc = getLocation(tz.data);
                if (source == null) {
                  source = new CalendarEventSource(loc);
                }
                return new Expanded(
                  child: new CalendarWidget(
                    initialDate: new TZDateTime.now(loc),
                    location: loc,
                    source: source,
                    bannerHeader:
                    new AssetImage("calendarheader.jpg"),
                    monthHeader:
                    new AssetImage("calendarbanner.jpg"),
                  ),
                );
              } else {
                return new Center(
                  child: new Text("Getting the timezone"),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CalendarEventSource extends CalendarSource {
  List<CalendarEvent> events = [];
  final Location loc;
  Random random = new Random();

  CalendarEventSource(this.loc);

  @override
  List<CalendarEvent> getEvents(DateTime start, DateTime end) {
    return events;
  }

  @override
  void dispose() {}

  @override
  void initState() {
    TZDateTime nowTime =
    new TZDateTime.now(loc).subtract(new Duration(days: 5));
    for (int i = 0; i < 20; i++) {
      TZDateTime start =
      nowTime.add(new Duration(days: i + random.nextInt(10)));
      events.add(new CalendarEvent(
          index: i,
          instant: start,
          instantEnd: start.add(new Duration(minutes: 30))));
    }
  }

  @override
  Widget buildWidget(BuildContext context, CalendarEvent index) {
    return new Card(
      child: new ListTile(
        title: new Text("Event ${index.index}"),
        subtitle: new Text("Yay for events"),
        leading: const Icon(Icons.gamepad),
      ),
    );
  }
}