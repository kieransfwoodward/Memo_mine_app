import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mine_app/tutorial_page.dart';

import 'CustomAppBar.dart';
import 'Strings.dart';
import 'TextStyles.dart';

class DashboardScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB98959),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.40,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/images/background.jpeg",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  Column(
                    children: <Widget>[
                      CustomAppBar(
                        opacity: 1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment(0, -0.6),
                          child: Text(
                            "Welcome to Portland Mine",
                            style: TextStyles.bigHeadingTextStyle,
                            textAlign: TextAlign.center,
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
            heightFactor: 0.65,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                color: Color(0xFF636E72),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Text(
                      "Total inscriptions:",
                      style: TextStyles.buttonTextStyle,
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
                            children: <Widget>[
                              const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                                size: 50.0,
                              ),
                              const Text(''),
                              const Text(
                                'View Inscriptions',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(15))),
                          padding: const EdgeInsets.all(30),
                          height: 180.0,
                          width: 180.0,
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
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 15.0, bottom: 15.0),
                          child: Column(
                            children: const <Widget>[
                              Icon(
                                Icons.draw_outlined,
                                color: Colors.black,
                                size: 50.0,
                              ),
                              Text(''),
                              Text(
                                'Create Inscription',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(15))),
                          padding: const EdgeInsets.all(30),
                          height: 180.0,
                          width: 180.0,
                        ),
                        onTap: () {
                          print("tapped on container");
                          Navigator.pushNamed(context, '/submit_drawings');
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
                                color: Colors.black,
                                size: 30.0,
                              ),
                              const Text(''),
                              const Text(
                                'Explore the Map',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(15))),
                          padding: const EdgeInsets.all(15),
                          height: 120.0,
                          width: 180.0,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardScreen()));
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
                                color: Colors.black,
                                size: 30.0,
                              ),
                              Text(''),
                              Text(
                                'Find Out More',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(15))),
                          padding: const EdgeInsets.all(15),
                          height: 120.0,
                          width: 180.0,
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
        ],
      ),
    );
  }
}