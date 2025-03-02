import 'dart:developer';
import 'package:flutter_application_4/home_page.dart';

import 'auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final _auth=AuthService();
  final TextEditingController _email=TextEditingController();   
  final TextEditingController _password=TextEditingController();   
  final TextEditingController _username=TextEditingController();   
  void dispose(){
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sign'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _username,
              decoration: InputDecoration(
                  hintText: 'username', border: OutlineInputBorder()),
            ),
          ),
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
              
              _signup();
            },
            child: Text('sign-up'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          Text('login'),
          TextButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return Loginpage();
            }));
          }, child: Text('login page'))
        ]),
      ),
    );
  }
  goToHome(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext){
      return HomePage();
    }));
  }
  _signup() async {
    
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Succesfully");
      goToHome(context);
    }
 }
}
 