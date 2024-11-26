import 'package:flutter/material.dart';

import 'Strings.dart';
import 'TextStyles.dart';



class CustomAppBar extends StatelessWidget {

  final double opacity;

  const CustomAppBar({this.opacity = 0.9}) : super();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.only(top: 48, left: 8, right: 8),
        child: Row(
          children: <Widget>[


            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/logo.png', height: 40),
            ),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Memo Project inscription",
                    style: TextStyles.appNameTextStyle,
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: "www.edenportland.org",
                    style: TextStyles.tagLineTextStyle,
                  ),
                  // TextSpan(text: "\n"),
                  // TextSpan(
                  //   text: "Make your mark for biodiversity",
                  //   style: TextStyles.tagLineTextStyle,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/ntu.png', height: 40),
            ),


            // Spacer(),
            // Icon(
            //   Icons.menu,
            //   color: Colors.white,
            // ),
          ],
        ),
      ),
    );
  }
}