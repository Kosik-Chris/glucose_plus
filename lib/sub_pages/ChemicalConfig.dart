import 'package:flutter/material.dart';
import 'package:glucose_plus/Connection/ChemicalsFire.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';
import 'package:glucose_plus/dialogue_pages/NewChemicalConfigDialog.dart';
import 'package:glucose_plus/dialogue_pages/EditChemicalConfigDialog.dart';
import 'package:glucose_plus/main_pages/home_page.dart';


class ChemicalsMain extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new ChemicalsMainState();
  }
}

class ChemicalsMainState extends State<ChemicalsMain> {
  ScrollController _listViewScrollController = new ScrollController();
  List<ChemicalsFire> chemicals = List();
  ChemicalsFire chemicalsFire;
  DatabaseReference chemRef;
  double _itemExtent = 50.0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    chemRef = FirebaseDatabase.instance.reference().child('chemicals');
    chemRef.onChildAdded.listen(_onEntryAdded);
    chemRef.onChildChanged.listen(_onEntryEdited);
    chemRef.onChildRemoved.listen(_onEntryDeleted);
  }

  _onEntryAdded(Event event) {
    setState(() {
      chemicals.add(new ChemicalsFire.fromSnapshot(event.snapshot));
    });
    _scrollToTop();
  }
  _onEntryDeleted(Event event){
    //TODO: FIX THIS
    var oldValue = chemicals.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
        _showSnackBar(context, "Entry Deleted");
    });
  }

  _deleteEntry(index){
    chemicals.removeAt(index);
    chemRef.child(chemicals[index].key).remove();
  }

  _onEntryEdited(Event event) {
    var oldValue =
    chemicals.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      chemicals[chemicals.indexOf(oldValue)] =
      new ChemicalsFire.fromSnapshot(event.snapshot);
    });
  }

  _scrollToTop() {
    _listViewScrollController.animateTo(
      chemicals.length * _itemExtent,
      duration: const Duration(microseconds: 1),
      curve: new ElasticInCurve(0.01),
    );
  }

  _openEditEntryDialog(ChemicalsFire chemical) {
    Navigator
        .of(context)
        .push(
      new MaterialPageRoute<ChemicalsFire>(
        builder: (BuildContext context) {
          return new EditChemConfigDialog.edit(chemical);
        },
        fullscreenDialog: true,
      ),
    )
        .then((ChemicalsFire newEntry) {
      if (newEntry != null) {
        chemRef.child(chemical.key).set(newEntry.toJson());
      }
    });
  }

  Widget _buildListItem(index){
    ChemicalsFire chemicalSend = chemicals.elementAt(index);
    return new Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: new Container(
          color: Colors.white,
          child: new ListTile(
            leading: new CircleAvatar(
              backgroundColor: Colors.cyan,
              child: new Text(chemicals[index].reference),
              foregroundColor: Colors.white,
            ),
            title: new Text(chemicals[index].title),
            subtitle: new Text(chemicals[index].mode),
          ),
        ),
        actions: <Widget>[
      new IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () =>
          //Error with this in that it is saying invalid arguments/no chemicals?
          //Ensure chemical value is sent ?? attempted through elementAt method
          _openEditEntryDialog(chemicalSend),

        ),
        ],
    secondaryActions: <Widget>[
      new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteEntry(index),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        body: ListView.builder(
          controller: _listViewScrollController,
          itemCount: chemicals.length,
                    itemBuilder: (context, index) =>
                    _buildListItem(index),

                    ),
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(

            backgroundColor: const Color(0xFF0099ed),
            child: Icon(Icons.add),
            onPressed: (){

              //User can select whether to save, send, discard.
              //Add other features later.
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewChemConfigDialogue()));
            }

        ),

      ),

    );
  }


  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }

}


