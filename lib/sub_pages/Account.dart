import 'package:flutter/material.dart';

class Account extends StatefulWidget {

  State<StatefulWidget> createState(){

    return new AccountState();
  }
}

class AccountState extends State<Account>{




  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.cyan,
      ),
      title: 'Glucose+',
      home: new Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.cyanAccent),
            ),
            Center(
              child: new Text("Account temp"),
            )
          ],
        ),
      ),
    );

  }

}