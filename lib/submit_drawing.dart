import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
//import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mine_app/main.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_storage/environment.dart';
import 'package:mine_app/StringExtension.dart';
import 'package:flutter/services.dart';

import 'certificate.dart';

const directoryName = 'MineApp';

class SubmitDrawing extends StatefulWidget {
  SubmitDrawing({Key? key}) : super(key: key);
  @override
  _SubmitDrawingState createState() => _SubmitDrawingState();
}

class _SubmitDrawingState extends State<SubmitDrawing> {
  final _schoolController = TextEditingController();
  final _statementController = TextEditingController();
  final _emailController = TextEditingController();

  Color selectedColor = Colors.black;
  Color pickerColor = Colors.white;
  double strokeWidth = 30.0;
  List<DrawingPoints?> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  var image;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.round : StrokeCap.round;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String img_url2 = "";
  String school = "";
  String statement = "";
  String email = "";
  bool isChecked = true;
  String lon = "";
  String lat = "";

  void initState() {
    super.initState();
  //  _determinePosition();
  }



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  setRenderedImage(BuildContext context) async {
    ui.Image renderedImage = await rendered;
    print("SETTING RENDERED IMAGE");
    setState(() {
      image = renderedImage;
    });

    showImage(context);
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    canvas.drawPaint(ui.Paint()..color = const ui.Color(0x00FF00));
    final paint = Paint()..color = Colors.black12;
   // canvas.drawCircle(ui.Offset.zero, 200, paint);
   //  canvas.drawColor(Colors.black12, BlendMode.color);

    // canvas.drawImage(intermediateImage, Offset.zero, Paint());



    DrawingPainter painter = DrawingPainter(pointsList: points);
    var size = const Size(400, 400);
    painter.paint(canvas, size);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  Future<Null> showImage(BuildContext context) async {

    if(isChecked){
      Position position = await _determinePosition();
     // Position position = await Geolocator.getCurrentPosition();
       lat = position.latitude.toString();
       lon = position.longitude.toString();
    }
    else{
       lat = "0";
       lon = "0";
    }


    final storageRef = FirebaseStorage.instance.ref();
    String filename = generateRandomString(15) + ".png";
    final mineRef = storageRef.child(filename);
    print("MADE IT INTO SHOWIMAGE");
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await Permission.storage.request();
    Directory? directory =
        await getApplicationDocumentsDirectory();
    String path = directory!.path;
    await Directory('$path/$directoryName').create(recursive: true);
    File file = File('$path/$directoryName/MINE_APP_ENGRAVING.png');
    file.writeAsBytesSync(pngBytes.buffer.asInt8List());
    mineRef.putFile(file).then((snapshot) {
      snapshot.ref.getDownloadURL().then((img_url) {
        img_url2 = img_url;
        school = _schoolController.text.toString().capitalize();
        statement = _statementController.text.toString().capitalize();
        var img_data = {
          'school': _schoolController.text.toString().capitalize(),
          'statement': _statementController.text.toString().capitalize(),
          'latitude': lat,
          'longitude': lon,
          'url': img_url
        };
        db.collection("portland_engravings").add(img_data);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => certificate(text: img_url2, school: school, statement: statement),
            ));
      });
    });

    // showDialog(
    //     context: context,
    //     builder: (BuildContext dialogContext) {
    //       Widget okButton = TextButton(
    //         child: Text("OK"),
    //         onPressed: () {
    //            Navigator.of(context, rootNavigator: true).pop('dialog');
    //           // Navigator.of(context).pop();
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => certificate(text: img_url2, school: school, statement: statement),
    //               ));
    //         },
    //       );
    //
    //       return AlertDialog(
    //         title: Text("Engraving Submitted!"),
    //         content: Text("You have submitted your engraving!"),
    //         actions: [
    //           okButton,
    //         ],
    //       );
    //     });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Color(0xFF005262);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: Text("Submit your mark"),
          backgroundColor: Color(0xFFCF5F32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: Text("Enter your School or Institution name:",
              //       style: TextStyle(fontSize: 18, color: Color(0xFF2D3436))),
              // ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  child: TextFormField(
                    controller: _schoolController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    obscureText: false,
                    style: TextStyle(color: Color(0xFF636E72), fontSize: 20),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: false,
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                         hintText: "Enter School or institution Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Text("Enter your Email:",
              //       style: TextStyle(fontSize: 20, color: Color(0xFF2D3436))),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: Text("Enter your personal statement:",
              //       style: TextStyle(fontSize: 20, color: Color(0xFF2D3436))),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  child: TextFormField(
                    controller: _statementController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    obscureText: false,
                    style: TextStyle(color: Color(0xFF636E72), fontSize: 20),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: false,
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Personal statement",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 40,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  obscureText: false,
                  style: TextStyle(color: Color(0xFF636E72), fontSize: 20),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: false,
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Email (optional)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
         // if()
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Text("Share location?",
              style: TextStyle(fontSize: 18, color: Color(0xFF2D3436))),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ],
          ),

              // Padding(
              //   padding: const EdgeInsets.all(0.0),
              //   child: Text(
              //     "Draw your Engraving:",
              //     style: TextStyle(fontSize: 20, color: Color(0xFF2D3436)),
              //   ),
              // ),
              Container(

                height: 350,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Color(0xFF2D3436), width: 3),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/ "),

                    ),
                    borderRadius: BorderRadius.circular(20)),

                child: ClipRect(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        points.add(DrawingPoints(
                            points:
                                renderBox.globalToLocal(details.localPosition),
                            paint: Paint()
                              ..strokeCap = strokeCap
                              ..isAntiAlias = true
                              ..color = selectedColor.withOpacity(opacity)
                              ..strokeWidth = strokeWidth));
                      });
                    },
                    onPanDown: (details) {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      setState(() {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        points.add(DrawingPoints(
                            points:
                                renderBox.globalToLocal(details.localPosition),
                            paint: Paint()
                              ..strokeCap = strokeCap
                              ..isAntiAlias = true
                              ..color = selectedColor.withOpacity(opacity)
                              ..strokeWidth = strokeWidth));
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(null);
                      });
                    },
                    child: CustomPaint(
                      size: const Size.square(1),
                      painter: DrawingPainter(
                        pointsList: points,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
             //   padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color:Color(0xFF990303),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width - 300,
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        onPressed: () {
                          points.clear();
                        },
                        child: Text(
                          "Start Again",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFCF5F32),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width - 300,
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          onPressed: () {
                            if (_schoolController.text.isNotEmpty && _statementController.text.isNotEmpty) {
                              print("Button has been pressed");
                              setRenderedImage(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    Widget okButton = TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true)
                                            .pop('dialog');
                                      },
                                    );

                                    return AlertDialog(
                                      title: Text("Error!"),
                                      content:
                                      Text("Ensure you have entered your school name and personal statement."),
                                      actions: [
                                        okButton,
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text(
                            "Submit Engraving",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});
  List<DrawingPoints?> pointsList;
  List<Offset> offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i]!.points, pointsList[i + 1]!.points,
            pointsList[i]!.paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i]!.points);
        offsetPoints.add(Offset(
            pointsList[i]!.points.dx + 0.1, pointsList[i]!.points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({required this.points, required this.paint});
}
