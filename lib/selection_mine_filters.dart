import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class MineSelectionFilters extends StatefulWidget {
  MineSelectionFilters({Key? key}) : super(key: key);
  @override
  _MineSelectionFiltersState createState() => _MineSelectionFiltersState();
}

class _MineSelectionFiltersState extends State<MineSelectionFilters> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              style: style,
              onPressed: () {},
              child: const Text(
                'Create',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 5,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
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
                        title: Text("Drawing Name"),
                        content: Text(_items[index].name),
                        actions: [
                          okButton,
                        ],
                      );
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(_items[index].image),
                  ),
                ),
              ),
            );
            // Item rendering
          },
        ),
      ),
    );
  }
}

class PhotoItem {
  final String image;
  final String name;
  PhotoItem(this.image, this.name);
}

final List<PhotoItem> _items = [
  // PhotoItem("assets/images/mine1.png", 'School A'),
  // PhotoItem('assets/images/mine2.png', 'School B'),
  // PhotoItem('assets/images/mine3.png', 'School C'),
  // PhotoItem('assets/images/mine4.png', 'School D'),
  // PhotoItem('assets/images/mine5.png', 'School E'),
  // PhotoItem('assets/images/mine6.png', 'School F'),
  // PhotoItem('assets/images/mine7.png', 'School G'),
  // PhotoItem('assets/images/mine8.png', 'School H'),
  // PhotoItem('assets/images/mine9.png', 'School I'),
  // PhotoItem('assets/images/mine10.png', 'School J'),
  // PhotoItem('assets/images/mine1.png', 'School K'),
  // PhotoItem('assets/images/mine2.png', 'School L'),
  // PhotoItem('assets/images/mine5.png', 'School E'),
  // PhotoItem('assets/images/mine6.png', 'School F'),
  // PhotoItem('assets/images/mine7.png', 'School G'),
  // PhotoItem('assets/images/mine8.png', 'School H'),
  // PhotoItem('assets/images/mine9.png', 'School I'),
  // PhotoItem('assets/images/mine10.png', 'School J'),
  // PhotoItem('assets/images/mine1.png', 'School K'),
  // PhotoItem('assets/images/mine2.png', 'School L'),
  // PhotoItem('assets/images/mine9.png', 'School I'),
  // PhotoItem('assets/images/mine10.png', 'School J'),
  // PhotoItem('assets/images/mine1.png', 'School K'),
  // PhotoItem('assets/images/mine2.png', 'School L'),
  // PhotoItem('assets/images/mine5.png', 'School E'),
  // PhotoItem('assets/images/mine6.png', 'School F'),
  // PhotoItem('assets/images/mine7.png', 'School G'),
  // PhotoItem('assets/images/mine8.png', 'School H'),
  // PhotoItem('assets/images/mine9.png', 'School I'),
  // PhotoItem('assets/images/mine10.png', 'School J'),
  // PhotoItem('assets/images/mine1.png', 'School K'),
  // PhotoItem('assets/images/mine2.png', 'School L'),
  // PhotoItem('assets/images/mine9.png', 'School I'),
  // PhotoItem('assets/images/mine10.png', 'School J'),
  // PhotoItem('assets/images/mine1.png', 'School K'),
  // PhotoItem('assets/images/mine2.png', 'School L'),
  // PhotoItem('assets/images/mine5.png', 'School E'),
  // PhotoItem('assets/images/mine6.png', 'School F'),
  // PhotoItem('assets/images/mine7.png', 'School G'),
  // PhotoItem('assets/images/mine8.png', 'School H'),
  // PhotoItem('assets/images/mine9.png', 'School I'),
  // PhotoItem('assets/images/mine10.png', 'School J'),
  // PhotoItem('assets/images/mine1.png', 'School K'),
  // PhotoItem('assets/images/mine2.png', 'School L'),
];
