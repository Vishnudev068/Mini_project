import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_4/home_page.dart';
import 'package:flutter_application_4/login.dart';
import 'package:flutter_application_4/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () {
      checkUserLogged();
    });  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('asset/images/output-onlinepngtools (1).png'),
            )

            //LoadingAnimationWidget.twistingDots(leftDotColor: Colors.red, rightDotColor: Colors.white38, size: 100),
          ],
        ),
      ),
    );
  }

  //shared_prefernce
  Future<void> gotoLogin() async {
    await Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              return Loginpage();
            },
          ),
        );
      },
    );
  }

  //shared_preference
  Future<void> checkUserLogged() async {
    final _sharedPref = await SharedPreferences.getInstance();
    final _userLog = _sharedPref.getBool(SAVE_KEY);
    if (_userLog == null || _userLog == false) {
      gotoLogin();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => HomePage(),
        ),
      );
    }
  }
}
