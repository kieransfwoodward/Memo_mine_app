
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mine_app/augmentedReality.dart';
import 'package:mine_app/main.dart';
import 'package:mine_app/viewing_wall.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_share/flutter_share.dart';




class certificate extends StatelessWidget {
  final String text, school, statement;
  int _counter = 0;
  late Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();


  // receive data from the FirstScreen as a parameter
  certificate({required this.text, required this.school, required this.statement}) : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

    // Image.asset(
    // "assets/images/background.jpeg",
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   fit: BoxFit.cover,
    // ),
    Scaffold(
   //   backgroundColor: Colors.lightBlueAccent[100],
    //  backgroundColor: Colors.transparent,
     // extendBodyBehindAppBar: true,

    appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Opacity( //Wrap your `AppBar`
          opacity: 0.7,
          child: AppBar(
            centerTitle: true,
            title: Text("Viewing wall"),
            backgroundColor: Color(0xFFCF5F32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            leading: BackButton(
            //  color: Color(0xFFFD879A),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WallViewing()));

               // print("back click");
              },
            ),
          ),
        ),
      ),
      body:
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("Inscription",
              //       style: GoogleFonts.anton(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 50,
              //         color: Colors.black45.withOpacity(0.5))),
              // ),

    Screenshot(
            controller: screenshotController,
             child:Container(
                  margin:
                  const EdgeInsets.only(top: 25.0, bottom: 5.0),
                  width: 350.0,
                  height: 350.0,
                  decoration: BoxDecoration(

                    border: Border.all(
                      width: 10,
                      color: Colors.black38
                    ),

                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/background2.jpeg"),

                    ),
                  ),
                  child: Opacity(
                    opacity: 0.5,
                      child: Image.network(text,fit: BoxFit.cover))
              ),
    ),




               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(statement,
                      style: GoogleFonts.tangerine(
                          fontSize: 40,
                          color: Colors.black54.withOpacity(1))),
               ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(school,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black54.withOpacity(0.5))),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFCF5F32),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width - 300,
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        onPressed: () {
                          const snackBar = SnackBar(
                            content: Text('Image has been saved to gallery'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          _save();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WallViewing()));
                        },
                        child: Text(
                          "Save Inscription",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),


                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     borderRadius: BorderRadius.circular(20),
                  //     color: Colors.red,
                  //     child: MaterialButton(
                  //       minWidth: MediaQuery.of(context).size.width - 300,
                  //       padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => MyApp(),
                  //             ));
                  //       },
                  //       // child: Text(
                  //       //   "Go Home",
                  //       //   style: TextStyle(fontSize: 15, color: Colors.white),
                  //       //   textAlign: TextAlign.center,
                  //       // ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              // if (Platform.isIOS) Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Material(
              //     borderRadius: BorderRadius.circular(20),
              //     color: Color(0xFFCF5F32),
              //     child: MaterialButton(
              //       minWidth: MediaQuery.of(context).size.width - 300,
              //       padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => AugmentedReality(url: text),
              //             ));
              //       },
              //       child: Text(
              //         " View in AR",
              //         style: TextStyle(fontSize: 15, color: Colors.white),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              // ),





            ],
          ),
        ),
      ),
    )]);

  }

  _save() async {
    //   var response = await Dio().get(
    //       text,
    //       options: Options(responseType: ResponseType.bytes));
    //   final result = await ImageGallerySaver.saveImage(
    //       Uint8List.fromList(response.data),
    //       quality: 60);
    //   print(result);
    //
    // }



    screenshotController.capture().then((Uint8List? image) {
      //Capture Done

      _imageFile = image!;

    }).catchError((onError) {
      print(onError);
    });

    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        String savePath = directory.path + "/image.png";
        await imagePath.writeAsBytes(image);


        final result = await ImageGallerySaver.saveFile(savePath);


        /// Share Plugin
       // await Share.shareFiles([imagePath.path]);
      }
    });

    // var appDocDir = await getTemporaryDirectory();
    // String savePath = appDocDir.path + "/temp.png";
    // await Dio().download(text, savePath);
    // final result = await ImageGallerySaver.saveFile(savePath);
  }

}