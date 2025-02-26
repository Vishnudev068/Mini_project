import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PharmacyInfo extends StatefulWidget {
  const PharmacyInfo({super.key});

  @override
  State<PharmacyInfo> createState() => _PharmacyInfoState();
}

class _PharmacyInfoState extends State<PharmacyInfo> {
  bool _isRed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 380,
              height: 320,
              decoration: BoxDecoration(
                // color: Colors.amber,
                borderRadius: BorderRadius.circular(0),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("asset/images/pharmacy1.jpg"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 38,
            left: 24,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.black.withOpacity(0.3),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 38,
            right: 18,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isRed = !_isRed;
                });
              },
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.black.withOpacity(0.4),
                    child: Icon(
                      Icons.favorite,
                      size: 20,
                      color: _isRed ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 290,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color.fromARGB(255, 22, 24, 55)
                    : Color.fromARGB(255, 239, 245, 235),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 32,
                ),
                child: SizedBox(
                  child: Text(
                    "Ashvas Pharmacy",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 324,
            left: 310,
            child: Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          Positioned(
            top: 324,
            left: 340,
            child: Text(
              "4.6",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            top: 370,
            left: 20,
            right: 20,
            child: const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          Positioned(
            top: 398,
            left: 20,
            right: 20,
            bottom: 20,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  width: 300,
                  height: 200,
                  // color: Colors.amber,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 10,
                        bottom: 0,
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: Text(
                          "This pharmacy offers a wide range of medical supplies and over-the-counter medications. It is well-known for providing quality care to its customers, with services available around the clock. Whether you need prescription medication or health advice, Ashvas Pharmacy is your reliable partner.",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 6.5,
                    left: 2,
                    right: 2,
                  ),
                  child: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.8,
                    left: 0,
                    right: 0,
                  ),
                  child: Container(
                    width: 280,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 12,
                          right: 30,
                          child: Text(
                            "About",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60,
                          left: 35,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: null,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.0),
                              //     blurRadius: 2,
                              //     spreadRadius: 0,
                              //     offset: Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.locationCrosshairs,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color.fromARGB(255, 21, 61, 138)
                                  : Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 52,
                          left: 84,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "KSFE Road",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Chinnakda,Kollam",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 122,
                          left: 20,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: null,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color:
                              //         const Color.fromARGB(255, 190, 168, 234),
                              //     blurRadius: 2,
                              //     spreadRadius: 0,
                              //     offset: Offset(0, 4),
                              //   )
                              // ],
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color.fromARGB(255, 21, 61, 138)
                                  : Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 128,
                          left: 84,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Open",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "24/7",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 200,
                          left: 20,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: null,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color:
                              //         const Color.fromARGB(255, 190, 168, 234),
                              //     blurRadius: 2,
                              //     spreadRadius: 0,
                              //     offset: Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color.fromARGB(255, 21, 61, 138)
                                  : Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200,
                          left: 84,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contact",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "154-678-9980",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
