import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';


/// chart data. Update/ receive this information from the new reading class
/// The double brackets seperate incoming data which is taken every 100 millisec
/// TODO: Make scrollable, add save button, add beautification
const data = [[1.0,0.0], [2.0,-0.2], [3.0,-0.9], [4.0,-0.5], [5.0,0.0], [6.0,0.5],
[7.0,0.6], [8.0,0.9], [9.0,0.8], [10.0,1.2], [11.0,0.5], [12.0,0.0]];


class Chart extends StatelessWidget {

/*  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButtonColumn(Icons.call, 'CALL'),
        buildButtonColumn(Icons.near_me, 'ROUTE'),
        buildButtonColumn(Icons.share, 'SHARE'),
      ],
    ),
  );*/

  //made each container a column variable
  //will display each column variable stacked on top of each other
  var buttonCol = Container(
    padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
    child: Column(
      children:[
        new Text("Buttons here"),
        new Text("More buttons!!!!"),
      ],
    ),
  );

  var chartCol = Container(
    padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
    child: Column(
      children: <Widget>[
        new LineChart(lines: [
          new Line<List<double>, double, double>(
            data: data,
            xFn: (datum) => datum[0],
            yFn: (datum) => datum[1],
          ),
        ],chartPadding: new EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 30.0),
  )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new LineChart(
      lines: [
        new Line<List<double>, double, double>(
          data: data,
          xFn: (datum) => datum[0],
          yFn: (datum) => datum[1],
        ),
      ],
      chartPadding: new EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 30.0),
    );
  }
}