import 'package:flutter/material.dart';
import 'package:glucose_plus/record_pages/chemical_list.dart';
import 'package:glucose_plus/dialogue_pages/ChemConfigueDialogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';
import 'package:glucose_plus/Firebase/Details.dart';


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

    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      key: new ValueKey(document.documentID),
      child: new Container(
        color: Colors.white,
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: new Text(document['reference'].toString()),
            foregroundColor: Colors.white,
          ),
          title: new Text(document['title']),
          subtitle: new Text(document['mode']),
        ),
      ),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () =>


              Navigator.of(context).push(new MaterialPageRoute(
              builder: (context){
                Details details = new Details(document['amount'],
                    document['loadResistor'],document['reference'],
                    document['title'],document['autoCalibrate'],
                    document['biasSign'],document['biasVoltage'],
                    document['chemical'],document['concentration'],
                    document['currTimeSamplePeriod'],document['gain'],
                    document['graphType'],document['mode'],
                    document['refSource'],document['voltCurrSamplePeriod']);
                ChemConfigDialogueState(document);
                return new ChemConfigDialogue(details: details);
                //send Chem config dialogue values from server
              },
              fullscreenDialog: true
          )),
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _showSnackBar(context,'Delete'),
        ),
      ],
    );

////      onTap: () => Firestore.instance.runTransaction((transaction) async {
////        DocumentSnapshot freshSnap =
////        await transaction.get(document.reference);
////        await transaction.update(
////            freshSnap.reference, {'reference': freshSnap['reference'] + 1});
////      }),
//
//    );
  }

  void updateFirebase(){

  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
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


