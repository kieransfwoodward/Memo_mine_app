import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:core';

import 'certificate.dart';

class MineSelection extends StatefulWidget {
  MineSelection({Key? key}) : super(key: key);
  @override
  _MineSelectionState createState() => _MineSelectionState();
}

//Adding a comment here to test my new PCs committing feature
class MapMarker {
  final String school;
  final String statement;
  //final String snippet;
  final String latitude;
  final String longitude;
  final String url;
 // final int zoom;

  MapMarker(
      {
        required this.school,
        required this.statement,
     // required this.title,
     // required this.snippet,
      required this.latitude,
        required this.longitude,
        required this.url,
    //  required this.zoom
      });

  factory MapMarker.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return MapMarker(
        school: doc.data()!['school'],
        statement: doc.data()!['statement'],
        url: doc.data()!['url'],
      //  snippet: doc.data()!['snippet'],
        latitude: doc.data()!['latitude'],
        longitude: doc.data()!['longitude']
      //  zoom: doc.data()!['zoom']
    );
  }
}

class _MineSelectionState extends State<MineSelection> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _googleMarkers = [];
  final databaseRef = FirebaseFirestore.instance;

  Stream<List<MapMarker>> fetchMarkers() {
    try {
      return databaseRef
          .collection("portland_engravings")
          .snapshots()
          .map((markers) {
        final List<MapMarker> notesFromFirestore = <MapMarker>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in markers.docs) {
          notesFromFirestore.add(MapMarker.fromDocumentSnapshot(doc: doc));
        }
        return notesFromFirestore;
      });
    } catch (e) {
      rethrow;
    }


    // try {
    //   return databaseRef
    //       .collection("mine_locations")
    //       .snapshots()
    //       .map((markers) {
    //     final List<MapMarker> notesFromFirestore = <MapMarker>[];
    //     for (final DocumentSnapshot<Map<String, dynamic>> doc in markers.docs) {
    //       notesFromFirestore.add(MapMarker.fromDocumentSnapshot(doc: doc));
    //     }
    //     return notesFromFirestore;
    //   });
    // } catch (e) {
    //   rethrow;
    // }
  }

  static final CameraPosition _ukMap = CameraPosition(
    target: LatLng(54.7281070243699, -4.214778989553452),
    zoom: 5,
  );

  void addLocalMarkersToGoogleMarkers(List<MapMarker> _mapMarkers) {
    for (MapMarker mapMarker in _mapMarkers) {
      print("INSIDE THE LOCAL: Inside the add Local");
      // String lat = mapMarker[index].url
      double lat = double.parse(mapMarker.latitude);
      double long = double.parse(mapMarker.longitude);
      LatLng latlangConvert = LatLng(lat, long);

      if(lat != 0 && long != 0){
        _googleMarkers.add(Marker(
            markerId: MarkerId(mapMarker.statement+mapMarker.school),
            position: latlangConvert,
            infoWindow: InfoWindow(
              title: mapMarker.statement,
              snippet: mapMarker.school,
            ),
            onTap: () {
              _goToPressedMarker(mapMarker);
            }));
      }

      print(_mapMarkers.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMarkers().listen((event) {
      addLocalMarkersToGoogleMarkers(event);
    });
    //addLocalMarkersToGoogleMarkers();
  }

  Future<void> _goToPressedMarker(MapMarker mapMarker) async {
    double lat = double.parse(mapMarker.latitude);
    double long = double.parse(mapMarker.longitude);
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(lat, long), 15));
    setState(() {
      showMaterialModalBottomSheet(
        isDismissible: true,
        enableDrag: true,
        duration: Duration(seconds: 1),
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[500],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width - 50,
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => certificate(text: mapMarker.url, school: mapMarker.school, statement: mapMarker.statement),
                        ));
                  },
                  child: Text(
                    "View Engraving",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Material(
              //   borderRadius: BorderRadius.circular(20),
              //   color: Colors.blue[800],
              //   child: MaterialButton(
              //     minWidth: MediaQuery.of(context).size.width - 50,
              //     padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/submit_drawings');
              //     },
              //     child: Text(
              //       "Create Engraving",
              //       style: TextStyle(fontSize: 30, color: Colors.white),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fetchMarkers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              //extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  centerTitle: true,
                  title: Text("Map"),
                  backgroundColor: Color(0xFFCF5F32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Colors.white60),
                    //   width: 250,
                    //   height: 100,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: <Widget>[
                    //       // Container(
                    //       //     width: 105,
                    //       //     height: 105,
                    //       //     decoration: BoxDecoration(
                    //       //       image: DecorationImage(
                    //       //         image:
                    //       //             AssetImage('assets/images/un_logo.png'),
                    //       //       ),
                    //       //     )),
                    //       // SizedBox(
                    //       //   width: 10,
                    //       // ),
                    //       // Text(
                    //       //   "Temp\nApp\nName",
                    //       //   style: TextStyle(
                    //       //       fontSize: 25,
                    //       //       color: Colors.blue[500],
                    //       //       fontWeight: FontWeight.bold),
                    //       //   textAlign: TextAlign.left,
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 40,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Pick a location to view inscriptions",
                        style: TextStyle(color: Color(0xFF2D3436), fontSize: 22),
                      ),
                    ),
                    SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width - 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GoogleMap(
                        onTap: (LatLng) {
                          // ignore: avoid_print
                          //print(LatLng.latitude);
                         // print(LatLng.longitude);
                        },
                        markers: Set<Marker>.of(_googleMarkers),
                        mapType: MapType.terrain,
                        tiltGesturesEnabled: false,
                        initialCameraPosition: _ukMap,
                        rotateGesturesEnabled: false,
                        mapToolbarEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.error_rounded,
                      color: Colors.red,
                      size: 200,
                    ),
                    Text(
                      "An Error has Occured.",
                      style: TextStyle(color: Colors.red, fontSize: 30),
                    ),
                    Text(
                      "Make sure that you have an internet connection.",
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Error Message:\n" + snapshot.error.toString(),
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        color: Colors.blue[500],
                        strokeWidth: 10,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Loading...",
                      style: TextStyle(color: Colors.grey, fontSize: 30),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
