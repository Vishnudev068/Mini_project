import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_4/global.dart';
import 'package:flutter_application_4/home_page.dart';
import 'package:flutter_application_4/login.dart';

import 'package:flutter_application_4/services/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

// ignore: camel_case_types
class _splashscreenState extends State<splashscreen>
    with SingleTickerProviderStateMixin {
  final FirestoreServices _firestore = FirestoreServices();
  @override
  void initState() {
  
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _firestore.removePastAppointments();
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
        // ignore: use_build_context_synchronously
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? storedUserId = prefs.getString('userId');

    if (isLoggedIn && storedUserId != null) {
      // Restore user ID globally
      GlobalState().setUserId(storedUserId);

      // Navigate to Home
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => HomePage(),
        ),
      );
    } else {
      gotoLogin(); // Navigate to login screen if user is not logged in
    }
  }
}
