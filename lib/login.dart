import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/auth_service.dart';
import 'package:flutter_application_4/home_page.dart';
import 'package:flutter_application_4/sign-up.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _auth =AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password= TextEditingController();
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _email,
              decoration: InputDecoration(
                  hintText: 'emailaddresss', border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _password,
              decoration: InputDecoration(
                  hintText: 'password', border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
            onPressed: () {
            _login();
            },
            child: Text('login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          Text('already have an account'),
          TextButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return signup();
            }));
          }, child: Text('sign-up'))
        ]),
      ),
    );
  }
   goToHome(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext){
      return HomePage();
    }));
  }
   _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      goToHome(context);
    }
  }
}
