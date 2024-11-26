import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mine_app/main.dart';

import 'certificate.dart';

class WallViewing extends StatefulWidget {
  WallViewing({Key? key}) : super(key: key);
  @override
  _WallViewingState createState() => _WallViewingState();
}

class Engraving {
  final String school;
  final String url;
  final String statement;

  Engraving({required this.school, required this.url, required this.statement});

  factory Engraving.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return Engraving(
      school: doc.data()!['school'],
      url: doc.data()!['url'],
      statement: doc.data()!['statement'],
    );
  }
}

class _WallViewingState extends State<WallViewing> {
  final databaseRef = FirebaseFirestore.instance;

  List<Engraving> _engravings = [];

  Stream<List<Engraving>> fetchEngravings() {
    try {
      return databaseRef
          .collection("portland_engravings")
          .snapshots()
          .map((engravings) {
        final List<Engraving> notesFromFirestore = <Engraving>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc
            in engravings.docs) {
          notesFromFirestore.add(Engraving.fromDocumentSnapshot(doc: doc));
        }
        return notesFromFirestore;
      });
    } catch (e) {
      rethrow;
    }
  }

  void addEngravingsToList(List<Engraving> engravings) {
    for (Engraving eng in engravings) {
      print(eng.school.toString());
      print(eng.url.toString());
      print(eng..toString());
      _engravings.add(eng);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEngravings().listen((event) {
      addEngravingsToList(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
     StreamBuilder(
        stream: fetchEngravings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return
          Scaffold(
              extendBodyBehindAppBar: true,
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
                                builder: (context) => MyApp()));

                        // print("back click");
                      },
                    ),
                  ),
                ),
              ),
             // backgroundColor: Color.fromRGBO(230, 230, 235, 1),
              body:  Container(
              decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background.jpeg"),
          fit: BoxFit.cover,
          ),
          ),
          child: Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: 3,
                    ),
                    itemCount: _engravings.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => certificate(text: _engravings[index].url, school: _engravings[index].school, statement: _engravings[index].statement),
                              ));
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext dialogContext) {
                          //       Widget okButton = TextButton(
                          //         child: Text("OK"),
                          //         onPressed: () {
                          //           Navigator.of(context, rootNavigator: true)
                          //               .pop('dialog');
                          //         },
                          //       );
                          //
                          //       return AlertDialog(
                          //         title: Text(_engravings[index].school),
                          //         content: Text(_engravings[index].statement),
                          //         actions: [
                          //           okButton,
                          //         ],
                          //       );
                          //     });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_engravings[index].url),
                              ),
                            ),
                          ),
                        ),
                      );
                      // Item rendering
                    },
                  ),
                ),
              ),
            ));
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
          }
     );
  }

}
