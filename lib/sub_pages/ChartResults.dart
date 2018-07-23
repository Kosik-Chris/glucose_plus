import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:glucose_plus/record_pages/chart_choices.dart';


/// chart data. Update/ receive this information from the new reading class
/// The double brackets seperate incoming data which is taken every 100 millisec
/// TODO: Make scrollable, add save button, add beautification
const data = [[1.0,0.0], [2.0,0.2], [3.0,0.9], [4.0,0.5], [5.0,0.0], [6.0,0.5],
[7.0,0.6], [8.0,0.9], [9.0,0.8], [10.0,1.2], [11.0,0.5], [12.0,0.0]];

const data2 = [[1.0,0.0], [2.0,0.8], [3.0,0.9], [4.0,0.9], [5.0,0.0], [6.0,3.5],
[7.0,0.6], [8.0,1.9], [9.0,1.8], [10.0,10.2], [11.0,1.5], [12.0,0.0]];


class Charts extends StatefulWidget {
  Charts({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChartsState createState() => new _ChartsState();
}

class _ChartsState extends State<Charts> with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {

    final xAxis = new ChartAxis<double>(
      span: new DoubleSpan(0.0, 12.0),
      tickGenerator: IntervalTickGenerator.byN(1.0),
    );
    final yAxis = new ChartAxis<double>(
      span: new DoubleSpan(0.0, 12.0),
      tickGenerator:  IntervalTickGenerator.byN(1.0),
    );
      return new AspectRatio(aspectRatio: 3/3,
      child: new LineChart(chartPadding: new EdgeInsets.fromLTRB(60.0, 20.0, 30.0, 30.0),
          lines: [
          new Line<List<double>, double, double>(
        data: data,
        xFn: (datum) => datum[0],
        yFn: (datum) => datum[1],
            xAxis: xAxis,
            yAxis: yAxis,
            marker: const MarkerOptions(
              paint: const PaintOptions.fill(color: Colors.blue),
            ),
            stroke: const PaintOptions.stroke(color: Colors.blue),
            legend: new LegendItem(
              paint: const PaintOptions.fill(color: Colors.blue),
              text: 'Foward Series',
            ),
      ),

        new Line<List<double>, double,double>(
          data: data2,
          xFn: (datum) => datum[0],
          yFn: (datum) => datum[1],
          xAxis: xAxis,
          yAxis: yAxis,
//          yAxis: ChartAxis(
////              span: new DoubleSpan(0.0, 30.0),
////              opposite: true,
////              tickGenerator: IntervalTickGenerator.byN(1.0),
//              paint: const PaintOptions.stroke(color: Colors.red)
//          ),
          marker: const MarkerOptions(
            paint: const PaintOptions.fill(color: Colors.red),
          ),
          stroke: const PaintOptions.stroke(color: Colors.red),
          legend: new LegendItem(
            paint: const PaintOptions.fill(color: Colors.red),
            text: 'Backward Series',
          ),
        ),

      ]),
      );

  }
}

