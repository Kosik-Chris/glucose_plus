import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:glucose_plus/main_pages/home_page.dart';


/// chart data. Update/ receive this information from the new reading class
/// The double brackets seperate incoming data which is taken every 100 millisec
/// TODO: Make scrollable, add save button, add beautification
const data = [[1.0,0.0], [2.0,-0.2], [3.0,-0.9], [4.0,-0.5], [5.0,0.0], [6.0,0.5],
[7.0,0.6], [8.0,0.9], [9.0,0.8], [10.0,1.2], [11.0,0.5], [12.0,0.0]];

const data2 = [[1.0,0.0], [2.0,0.8], [3.0,0.9], [4.0,0.9], [5.0,0.0], [6.0,3.5],
[7.0,0.6], [8.0,1.9], [9.0,1.8], [10.0,10.2], [11.0,1.5], [12.0,0.0]];




class NewResults extends StatefulWidget {

  State<StatefulWidget> createState(){
    return new NewResultsMainState();
  }
}

class NewResultsMainState extends State<NewResults> with SingleTickerProviderStateMixin {

  Chemicals selectedChemical;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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


     return new MaterialApp(
       theme: new ThemeData(
         primaryColor: Colors.cyan,
       ),
       title: 'Glucose+',
       home: new Scaffold(
         appBar: new AppBar(
           title: new Text("Reading results"),
           actions: <Widget>[
              new IconButton(icon: new Icon(Icons.home), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    HomePage()
                  ));
              })
           ],
         ),
         body: new AspectRatio(aspectRatio: 3/3,
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
         )
       ),
     );

  }
}

//      return new Scaffold(
//        body: Stack(
//          fit: StackFit.expand,
//          children: <Widget>[
//            Container(
//              decoration: BoxDecoration(color: Colors.white),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                //Top Row for buttons/ options etc
//
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//
//                    ButtonBar(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        DropdownButton<Chemicals>(
//                            hint: new Text("Select a Chemical"),
//                            value: selectedChemical,
//
//                            items: ChemicalsValues.map((Chemicals chemical) {
//                              return new DropdownMenuItem<Chemicals>(
//                                value: chemical,
//                                child: new Text(chemical.title,
//                                  style: new TextStyle(color: Colors.black),
//                                ),
//                              );
//                            }
//                            ).toList(),
//                            onChanged: (Chemicals newChem) {
//                              setState(() {
//                                selectedChemical = newChem;
//                              });
//
//                            }
//                        ),
//                        TextField(
//                          textAlign: TextAlign.right,
//                          decoration: InputDecoration(
//                              border: InputBorder.none,
//                              hintText: 'Please enter test name'
//                          ),
//                        )
//                      ],
//
//                    )
//                  ],
//                ),
//                //Place where graph is rendered
//                 AspectRatio(
//                  aspectRatio: 4/3,
//
//
//                  child: new LineChart(chartPadding: new EdgeInsets.fromLTRB(60.0, 20.0, 30.0, 30.0),
//                      lines: [
//                        new Line<List<double>, double, double>(
//                          data: data,
//                          xFn: (datum) => datum[0],
//                          yFn: (datum) => datum[1],
//                          xAxis: xAxis,
//                          yAxis: yAxis,
//                          marker: const MarkerOptions(
//                            paint: const PaintOptions.fill(color: Colors.blue),
//                          ),
//                          stroke: const PaintOptions.stroke(color: Colors.blue),
//                          legend: new LegendItem(
//                            paint: const PaintOptions.fill(color: Colors.blue),
//                            text: 'Foward Series',
//                          ),
//                        ),
//
//                        new Line<List<double>, double,double>(
//                          data: data2,
//                          xFn: (datum) => datum[0],
//                          yFn: (datum) => datum[1],
//                          xAxis: xAxis,
//                          yAxis: yAxis,
//                          marker: const MarkerOptions(
//                            paint: const PaintOptions.fill(color: Colors.red),
//                          ),
//                          stroke: const PaintOptions.stroke(color: Colors.red),
//                          legend: new LegendItem(
//                            paint: const PaintOptions.fill(color: Colors.red),
//                            text: 'Backward Series',
//                          ),
//                        ),
//
//                      ]),
//                )
//              ],
//            )
//          ],
//        ),
//
//      );
