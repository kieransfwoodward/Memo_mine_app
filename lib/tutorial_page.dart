import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';


import 'main.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: "K18cpp_-gP8",
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    super.initState();
  }


  setTutorialDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasDoneTutorial', true);
  }

  void _onIntroEnd(context) {
    setState(() {
      setTutorialDone();
    });


    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp()));


  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    String videoId = '70591644';

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
           // child: _buildImage('un_logo.png', 100),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          image: _buildImage('page1.jpg'),
          title: "The MEMO Project",
          body: "MEMO is a collaboration of artists and scientists dedicated to biodiversity.  We are working with the Eden Project to create a cultural destination to tell the greatest story of all - the story of life itself.  In an age of extinctions our mission is to build a global symbol to inspire the widest audience imaginable on the imperative to protect the diversity of life on Earth.",
          decoration: pageDecoration.copyWith(
            // contentMargin: const EdgeInsets.symmetric(horizontal: 12),
            // bodyFlex: 1,
            // imageFlex: 2,
          ),
        ),
        PageViewModel(
          image: _buildImage('inside.jpg'),
          title: "The Isle of Portland",
          body: "The Isle of Portland is a small island off the south coast of Britain.  Despite its size it is the perfect place for this project.  Portland offers a spectacular underground labyrinth possessed of an ancient Egyptian charisma and a clifftop quarry looking back to the mainland. Portland is part of the Jurassic Coast, a UNESCO World Heritage Site for the ancient story of life written in its rocks.  And the island is also the source of architectural stone in which the ideals of the United Nations are enshrined in New York.",
          decoration: pageDecoration.copyWith(
            // contentMargin: const EdgeInsets.symmetric(horizontal: 12),
            // bodyFlex: 1,
            // imageFlex: 2,
          ),
          // footer: VimeoVideoPlayer(
          //   vimeoPlayerModel: VimeoPlayerModel(
          //     url: 'https://vimeo.com/70591644',
          //     deviceOrientation: DeviceOrientation.portraitUp,
          //     systemUiOverlay: const [
          //       SystemUiOverlay.top,
          //       SystemUiOverlay.bottom,
          //     ],
          //   ),
          // ),

        ),

        PageViewModel(
          image:  _buildImage('page3.jpeg'),

          // YoutubePlayerIFrame(
          //   controller: _controller,
          //   aspectRatio: 16 / 9,
          // ),
          title: "The Inscription",
          body: "The inscription has been crafted with groups from the two schools on Portland.  We wanted to paint the very biggest of pictures and to send a message of hope.  It is being carved on the trunk of the tree sculpture right now. According to an old Portland tradition, 750 children on the island and nearly 2000 on the mainland have designed their mason's marks which will be carved under the inscription.  Please join them wherever you are by making your own virtual mark.  This is our one speck of the universe.",
          decoration: pageDecoration.copyWith(
            // contentMargin: const EdgeInsets.symmetric(horizontal: 12),
            // bodyFlex: 1,
            // imageFlex: 2,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Finish', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),

    // dotsDecorator: const DotsDecorator(
    // size: Size(10.0, 10.0),
    //   activeColor: Colors.black,
    // color: Colors.white,
    // activeSize: Size(22.0, 10.0),
    // activeShape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.all(Radius.circular(25.0)),
    // ),),
    //
    //   dotsContainerDecorator: ShapeDecoration(
    //     color: Color(0xFFB98959),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
    //     ),
    //   ),
    );
  }
}
