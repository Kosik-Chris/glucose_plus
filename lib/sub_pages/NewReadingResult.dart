import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:glucose_plus/main_pages/home_page.dart';


/// chart data. Update/ receive this information from the new reading class
/// The double brackets seperate incoming data which is taken every 100 millisec
/// TODO: Make scrollable, add save button, add beautification
const data = [[0.0,100.0], [0.5,150.0], [1.0,125.0], [1.5,175.0], [2.0,200.0], [2.5,225.0],
[3.0,250.0], [3.5,260.0], [4.0,270.0], [4.5,280.0], [5.0,285.0], [5.5,290.0], [6.0,295.0]];

const data2 = [[0.0,100.0], [0.5,-150.0], [1.0,-125.0], [1.5,-175.0], [2.0,-200.0], [2.5,-225.0],
[3.0,-250.0], [3.5,-260.0], [4.0,-270.0], [4.5,-280.0], [5.0,-285.0], [5.5,-290.0], [6.0, 295.0]];


enum saveAnswer{SaveAll,SavePic,SaveExcel}
enum discardAnswer{Yes,No}
enum exportAnswer{Yes,No}

class NewResults extends StatefulWidget {

  State<StatefulWidget> createState(){
    return new NewResultsMainState();
  }
}

class NewResultsMainState extends State<NewResults> with SingleTickerProviderStateMixin {


  Chemicals selectedChemical;
  int _bottomNavBarIndex = 0;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final xAxis = new ChartAxis<double>(
      span: new DoubleSpan(0.0, 6.0),
      tickGenerator: IntervalTickGenerator.byN(1.0),
    );
    final yAxis = new ChartAxis<double>(
      span: new DoubleSpan(-300.0, 300.0),
      tickGenerator:  IntervalTickGenerator.byN(50.0),
    );


     return new MaterialApp(
       theme: new ThemeData(
         primaryColor: Colors.cyan,
       ),
       title: 'Glucose+',
       home: new Scaffold(
         appBar: new AppBar(

           title: new Text("Reading results", textAlign: TextAlign.center,),
           actions: <Widget>[
              new IconButton(icon: new Icon(Icons.home), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    HomePage()
                  ));
              })
           ],
         ),
         body: Stack(
           fit: StackFit.expand,
           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(color: Colors.cyan),
//             ),
             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 ButtonBar(

                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     new Text("Selected Chemical"),
                     new Text("Units")
                   ],
                 ),
                 AspectRatio(aspectRatio: 3/3,
                   child: new LineChart(chartPadding: new EdgeInsets.fromLTRB(50.0, 30.0, 20.0, 10.0),
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
                 ),
               ],
             )
           ],
         ),
         bottomNavigationBar: BottomNavigationBar(
             currentIndex: _bottomNavBarIndex,
             onTap: (int index){
               if(index == 0){
                 //save image

               }
               if(index == 1){
                 //discard image and return home

               }
               if(index == 2){
                 //save image and open up email with image attached

               }
               setState(() {
                 _bottomNavBarIndex = index;
               });
             },
             items: [
               BottomNavigationBarItem(
                 icon: const Icon(Icons.save),
                 title: Text('Save'),

               ),

               BottomNavigationBarItem(
                 icon: const Icon(Icons.transfer_within_a_station),
                 title: Text('Discard'),
               ),

               BottomNavigationBarItem(
                 icon: const Icon(Icons.exit_to_app),
                 title: Text('Export'),
               )
             ]

         ),
       ),
     );

  }
}


