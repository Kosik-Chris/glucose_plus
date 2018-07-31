import 'package:flutter/material.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChemicalsMain extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new ChemicalsMainState();
  }
}

class ChemicalsMainState extends State<ChemicalsMain> {

//  Chemicals selectedChemical;
//  String configMsg = "HOLDER";

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new ListTile(
      leading: Icon(Icons.invert_colors),
      key: new ValueKey(document.documentID),
      title: new Container(
        decoration: new BoxDecoration(
          border: new Border.all(color: const Color(0x80000000)),
          borderRadius: new BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(document['title'],
              style: TextStyle(),),
            ),
          ],
        ),
      ),
//      onTap: () => Firestore.instance.runTransaction((transaction) async {
//        DocumentSnapshot freshSnap =
//        await transaction.get(document.reference);
//        await transaction.update(
//            freshSnap.reference, {'reference': freshSnap['reference'] + 1});
//      }),

    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color(0xFF229E9C),
      ),
      home: new Scaffold(
        backgroundColor: Colors.cyanAccent,
        body: new StreamBuilder(
        stream: Firestore.instance.collection('Chemicals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemExtent: 65.0,
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]),
          );
        }),
          floatingActionButton: FloatingActionButton(

              backgroundColor: const Color(0xFF0099ed),
              child: Icon(Icons.edit),
              onPressed: (){


              }

          )
      ),

    );
  }

  //Make sure all methods that call setState() are within Main state class
//  _chemConfig(){
//    //Upon selection of chemical this method configures settings and
//    //then calls another method to send the data configurations to MCU
//    try {
//      for (int i; i < ChemicalsValues.length; i++) {
//        if (selectedChemical == ChemicalsValues[i]) {
//          configMsg = 'Configuring' + ChemicalsValues[i].toString();
//        }
//      }
//    }catch(e){
//      print(e.toString());
//    }
//
//  }


}

