import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';


/// chart data. Update/ receive this information from the new reading class
/// The double brackets seperate incoming data which is taken every 100 millisec
/// TODO: Make scrollable, add save button, add beautification
const data = [[1.0,0.0], [2.0,-0.2], [3.0,-0.9], [4.0,-0.5], [5.0,0.0], [6.0,0.5],
[7.0,0.6], [8.0,0.9], [9.0,0.8], [10.0,1.2], [11.0,0.5], [12.0,0.0]];

const data2 = [[5.0,0.0], [7.0,0.8], [5.0,0.9], [1.0,0.9], [1.0,0.0], [2.0,3.5],
[20.0,0.6], [3.0,1.9], [5.0,1.8], [1.0,10.2], [11.0,1.5], [12.0,0.0]];


class Charts extends StatefulWidget {
  Charts({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChartsState createState() => new _ChartsState();
}

class _ChartsState extends State<Charts> with SingleTickerProviderStateMixin{


//  var chartCol = Container(
//    child: Column(
//      children: <Widget>[
//        new LineChart(lines: [
//          new Line<List<double>, double, double>(
//            data: data,
//            xFn: (datum) => datum[0],
//            yFn: (datum) => datum[1],
//          ),
//        ],chartPadding: new EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 30.0),
//        )
//      ],
//    ),
//  );

  @override
  Widget build(BuildContext context) {
//    return new LineChart(lines: [
//      new Line<List<double>, double, double>(
//        data: data,
//        xFn: (datum) => datum[0],
//        yFn: (datum) => datum[1],
//      ),
//    ],chartPadding: new EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 30.0),
//    );
    final xAxis = new ChartAxis<double>();
      return new AspectRatio(aspectRatio: 4/3,
      child: new LineChart(chartPadding: new EdgeInsets.fromLTRB(60.0, 20.0, 30.0, 30.0),
          lines: [
          new Line<List<double>, double, double>(
        data: data,
        xFn: (datum) => datum[0],
        yFn: (datum) => datum[1],
            xAxis: xAxis,
            yAxis: new ChartAxis(
              paint: const PaintOptions.stroke(color: Colors.blue),
            ),
            marker: const MarkerOptions(
              paint: const PaintOptions.fill(color: Colors.blue),
            ),
            stroke: const PaintOptions.stroke(color: Colors.blue),
            legend: new LegendItem(
              paint: const PaintOptions.fill(color: Colors.blue),
              text: 'Coolness',
            ),
      ),

        new Line<List<double>, double,double>(
          data: data2,
          xFn: (datum) => datum[0],
          yFn: (datum) => datum[1],
        ),

      ]),
      );

  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Save', icon: Icons.save),
  const Choice(title: 'Change graph type', icon: Icons.gradient),
  const Choice(title: 'Load external data', icon: Icons.file_upload),
  const Choice(title: 'Export Graph', icon: Icons.file_download)
];
