import 'package:flutter/material.dart';
import 'package:flutter_application_4/api/api_services.dart';
import 'package:flutter_application_4/home_page.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/screen_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();

  final _password = TextEditingController();

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    print("hello");
                    var data = {
                      'username': _username.text,
                      'password': _password.text
                    };
                    bool isSuccess = await ApiServices.login(data);
                    if (isSuccess) {
                      final _sharedPref = await SharedPreferences.getInstance();
                      await _sharedPref.setBool(SAVE_KEY, true);
                      _navigateToNextPage();
                    } else {}
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
