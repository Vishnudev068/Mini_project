import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/auth_service.dart';
import 'package:flutter_application_4/home_page.dart';
import 'package:flutter_application_4/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auth = AuthService();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _gender = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phoneNumber.dispose();
    _gender.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: _username,
                          labelText: 'USERNAME',
                          hintText: 'Enter your username',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _email,
                          labelText: 'E-MAIL',
                          hintText: 'example@gmail.com',
                          icon: Icons.email,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneNumber,
                          labelText: 'PHONE NUMBER',
                          hintText: 'Enter your phone number',
                          icon: Icons.phone,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _gender,
                          labelText: 'GENDER',
                          hintText: 'Male/Female/Other',
                          icon: Icons.transgender,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _password,
                          labelText: 'PASSWORD',
                          hintText: 'Enter your password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _confirmPassword,
                          labelText: 'CONFIRM PASSWORD',
                          hintText: 'Confirm your password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Loginpage(),
                                ));
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomePage(),
    ));
  }

  void _signup() async {
    // Validate passwords match
    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate required fields
    if (_username.text.isEmpty ||
        _email.text.isEmpty ||
        _phoneNumber.text.isEmpty ||
        _gender.text.isEmpty ||
        _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Register user
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Successfully");
      goToHome(context);
    }
  }
}
