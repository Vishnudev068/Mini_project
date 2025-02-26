import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  double _containerWidth = 200;
  double _containerHeight = 100;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
                top: 50,
                left: 101,
                right: 106.95,
                child: CircleAvatar(
                  backgroundImage: AssetImage('asset/images/man.png'),
                  radius: 100,
                )),
            Positioned(
                top: 260,
                left: 20,
                right: 20,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Full name'),
                )),
            Positioned(
                top: 340,
                left: 20,
                right: 20,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'emailaddress'),
                )),
            Positioned(
                top: 420,
                left: 20,
                right: 20,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'phonenumber'),
                )),
            Positioned(
                top: 500,
                left: 20,
                right: 20,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'password'),
                )),
            Positioned(
                top: 580,
                left: 60,
                right: 60,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Expand the container when tapped on mobile
                      if (_containerWidth == 200) {
                        _containerWidth = 250; // New expanded width
                        _containerHeight = 150; // New expanded height
                      } else {
                        _containerWidth = 200; // Original width
                        _containerHeight = 100; // Original height
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds: 200), // Smooth animation duration
                    width: _containerWidth, // Update width based on tap
                    height: _containerHeight, // Update height based on tap
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          print("Save button clicked");
                        },
                        child: Text('Click to Save'),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
