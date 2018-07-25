import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:glucose_plus/record_pages/chart_choices.dart';
import 'package:sliver_calendar/sliver_calendar.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';

/// TODO: Make scrollable, add save button, add beautification



class Charts extends StatefulWidget {
  Charts({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChartsState createState() => new _ChartsState();
}

class _ChartsState extends State<Charts> with SingleTickerProviderStateMixin{
  CalendarSource source;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title),
//      ),
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
