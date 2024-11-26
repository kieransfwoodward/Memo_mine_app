import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewDrawings extends StatefulWidget {
  ViewDrawings({Key? key}) : super(key: key);
  @override
  _ViewDrawingsState createState() => _ViewDrawingsState();
}

class _ViewDrawingsState extends State<ViewDrawings> {
  Future<String> fetchImage() async {
    final ref = FirebaseStorage.instance.ref().child('mine1.png');
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 400,
            width: 400,
            child: Image.network(
              snapshot.data.toString(),
              fit: BoxFit.fill,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
