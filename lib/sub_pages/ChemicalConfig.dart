import 'package:flutter/material.dart';

class Chemicals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color(0xFF229E9C),
      ),
      title: 'Branch Setup',
      home: new Scaffold(
        body: new Container(
          child: new ListView(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Row(
                  children: <Widget>[
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.all(16.0),
                child:
                new DropdownButton<String>(
                  items: <String>['Glucose','Chemical2','Chemical3',
                  'Chemical4','Chemical5','Chemical6','Chemical7']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }
                  ).toList(),
                  onChanged: null,
                ),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: null,
                      child: new Text('Configure'),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  }
