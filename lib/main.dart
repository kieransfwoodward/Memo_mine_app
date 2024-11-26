import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:introduction_screen/introduction_screen.dart';
import 'package:mine_app/DashboardScreen.dart';
import 'package:mine_app/selection_mine.dart';
import 'package:mine_app/selection_walls.dart';
import 'package:mine_app/submit_drawing.dart';
import 'package:mine_app/tutorial_page.dart';
import 'package:mine_app/viewing_wall.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomAppBar.dart';
import 'TextStyles.dart';
import 'selection_mine_filters.dart';
import 'viewing_drawings.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Introduction screen',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyApp(),

    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Mine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'The Portland Mine'),
      routes: <String, WidgetBuilder>{
        '/selection_mine': (BuildContext) => MineSelection(),
        '/selection_mine_filters': (BuildContext) => MineSelectionFilters(),
        '/selection_walls': (BuildContext) => WallSelection(),
        '/viewing_drawings': (BuildContext) => ViewDrawings(),
        '/viewing_wall': (BuildContext) => WallViewing(),
        '/submit_drawings': (BuildContext) => SubmitDrawing(),
        '/tutorial_page': (BuildContext) => OnBoardingPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Uint8List _imageFile;

  getTutorialDone() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('hasDoneTutorial') ?? false);
    if(_seen == false){
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new OnBoardingPage()));
    }
  }
  int count = 0;

  void countDocuments() async {
    FirebaseFirestore.instance.collection('portland_engravings').get().then((value) => {
    setState(() {count = value.docs.length;})
    });



  }

  void initState() {
    super.initState();
    getTutorialDone();
    countDocuments();
  //  _determinePosition();
  }


  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
           // heightFactor: 0.40,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/images/background.jpeg",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    children: <Widget>[
                      CustomAppBar(
                        opacity: 1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment(0, -0.9),
                          child: Opacity(
                            opacity: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5.0,0, 5.0, 0),
                              child: Text(
                                //"We have read about biodiversity loss. Words have not been enough. Make your mark to remember species gone extinct and demand action.",
                                "This is our one speck of the universe.\nMake your mark for biodiversity.",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontFamily: 'Ubuntu',
                                ),
                                textAlign: TextAlign.center,
                              ),

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                color: Color(0x88FFFFFF),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Text(
                          "Total inscriptions: " + "$count",
                          style: TextStyles.buttonTextStyle,
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     //child:
                    //   ),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0),
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  Icons.draw_outlined,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                                Text(''),
                                Text(
                                  'Create your mark',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFCF5F32),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(15))),
                            padding: const EdgeInsets.all(20),
                            height: 180.0,
                            width: (MediaQuery.of(context).size.width/2)-15,
                          ),
                          onTap: () {
                            print("tapped on container");
                            Navigator.pushNamed(context, '/submit_drawings');
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0),
                            child: Column(
                              children: <Widget>[
                                const Icon(
                                  Icons.picture_in_picture,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                                const Text(''),
                                const Text(
                                  'View marks',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFCF5F32),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(15))),
                            padding: const EdgeInsets.all(20),
                            height: 180.0,
                            width: (MediaQuery.of(context).size.width/2)-15,
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/viewing_wall');
                            //Navigator.push(
                            //  context,
                            //MaterialPageRoute(
                            //  builder: (context) =>
                            //    MineSelectionFilters()));
                          },
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 5.0, bottom: 5.0),
                            child: Column(
                              children: <Widget>[
                                const Icon(
                                  Icons.map_outlined,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                const Text(''),
                                const Text(
                                  'Map',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFCF5F32),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(15))),
                            padding: const EdgeInsets.all(15),
                            height: 120.0,
                            width: (MediaQuery.of(context).size.width/2)-15,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MineSelection()));
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0),
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                Text(''),
                                Text(
                                  'Info',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFCF5F32),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            padding: const EdgeInsets.all(15),
                            height: 120.0,
                            width: (MediaQuery.of(context).size.width/2)-15,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnBoardingPage()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
