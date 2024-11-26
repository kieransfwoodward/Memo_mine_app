import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallSelection extends StatefulWidget {
  WallSelection({Key? key}) : super(key: key);
  @override
  _WallSelectionState createState() => _WallSelectionState();
}

class _WallSelectionState extends State<WallSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "This is the Wall Selection Screen",
              style: TextStyle(fontSize: 30, color: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
