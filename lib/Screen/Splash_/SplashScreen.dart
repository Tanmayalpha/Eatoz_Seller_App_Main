import 'dart:async';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Helper/app_assets.dart';
import 'package:eshopmultivendor/Screen/Authentication/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    // ));

    super.initState();
    startTime();
  }

//==============================================================================
//============================= Build Method ===================================

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // decoration: back(),
        child: Image.asset(
          "assets/images/EatozBGGIF.gif",
          fit: BoxFit.fill,
        ),
      ),
      // Stack(
      //   children: <Widget>[
      //     Container(
      //       width: double.infinity,
      //       height: double.infinity,
      //       decoration: back(),
      //       child: Center(
      //         // child: SvgPicture.asset(
      //         //   'assets/images/splashlogo.svg',
      //         //   height: 250,
      //         //   width: 150,
      //         // ),
      //         child: Container(
      //           color: Colors.white,
      //           margin: EdgeInsets.all(MediaQuery.of(context).size.width / 60),
      //           child: Image.asset(
      //             Myassets.app_logo,
      //             height: MediaQuery.of(context).size.height / 6,
      //           ),
      //         ),
      //       ),
      //     ),
      //     Image.asset(
      //       'assets/images/EatozBGGIF.gif',
      //       fit: BoxFit.fill,
      //       width: double.infinity,
      //       height: double.infinity,
      //     ),
      //   ],
      // ),
    );
  }

  startTime() async {
    var _duration = Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    bool isFirstTime = await getPrefrenceBool(isLogin);

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }
  }

  @override
  void dispose() async {
    bool isFirstTime = await getPrefrenceBool(isLogin);

    if (isFirstTime) {
      print("go to home ");
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      //     overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   statusBarIconBrightness: Brightness.light,
      //   systemNavigationBarColor: Colors.transparent,
      // ));
    } else {
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      //     overlays: [SystemUiOverlay.top]);
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   statusBarIconBrightness: Brightness.light,
      //   systemNavigationBarColor: Colors.transparent,
      // ));
    }
    super.dispose();
  }
}
