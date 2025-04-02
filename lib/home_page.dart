import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/appointment.dart';
import 'package:flutter_application_4/depart_doc.dart';
import 'package:flutter_application_4/doctors_page.dart';
import 'package:flutter_application_4/global.dart';
import 'package:flutter_application_4/helpers/dailog_helper.dart';
import 'package:flutter_application_4/helpers/location_helper.dart';

import 'package:flutter_application_4/pharmacy_page.dart';
import 'package:flutter_application_4/profile_page.dart';
import 'package:flutter_application_4/screen_3.dart';
import 'package:flutter_application_4/services/firestore.dart';
import 'package:flutter_application_4/services/location_services.dart';
import 'package:flutter_application_4/settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Timer? _timer;
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _locationName = "Kottathala";
  String _locationDetails = "Kottarakkara, Kollam, Kerala";
  final FirestoreServices _firestore = FirestoreServices();
  final DialogHelper _dialogHelper = DialogHelper();
  int _selectedIndex = 0;
  FocusNode _focus = FocusNode();
  bool _isfocus = false;

  final List<String> departments = [
    "General Medicine",
    "Cardiology",
    "Neurology",
    "Orthopedics",
    "Gastroenterology",
    "Oncology",
    "Nephrology",
    "Pulmonology",
    "Endocrinology",
    "Pediatrics",
    "Gynecology",
    "Dermatology",
    "Ophthalmology",
    "Urology",
    "Psychiatry",
    "Radiology",
    "Anesthesiology",
    "Emergency Medicine",
    "Rheumatology",
    "Hematology",
    "Surgeon",
    "ENT",
    "Dentistry",
  ];

  String? doctorName;
  String? specialty;
  String? selectedDate;
  String? selectedTimeSlot;

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointmentAndDoctor();

    _timer = Timer.periodic(Duration(minutes: 2), (Timer t) {
      _fetchAppointmentAndDoctor();
    });
    WidgetsBinding.instance.addObserver(this);
    _requestLocationPermission();
    _focus.addListener(
      () {
        setState(() {
          _isfocus = _focus.hasFocus;
        });
      },
    );
  }

  void _requestLocationPermission() {
    LocationHelper.checkLocationPermission(context, () {
      // setState(() {
      //   _locationName =
      //       "Location Enabled"; // Change this based on actual location
      // });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchAppointmentAndDoctor();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    DoctorsPage(),
    ScanPage(),
    PharmacyPage(),
  ];
  void _onItemTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _pages[index],
      ),
    );
  }

  Future<void> _fetchAppointmentAndDoctor() async {
    String? userId = GlobalState().getUserId();

    // Fetch latest appointment
    var appointment = await _firestore.getLatestAppointment(userId!);

    if (appointment != null) {
      String doctorId = appointment['doctorId'];
      selectedDate = appointment['selectedDate'];
      selectedTimeSlot = appointment['selectedTimeSlot'];

      var doctorDetails = await _firestore.getDoctorDetails(doctorId);
      if (doctorDetails != null) {
        setState(() {
          doctorName = doctorDetails['name'];
          specialty = doctorDetails['speciality'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color.fromARGB(255, 30, 40, 80)
                  : Color.fromARGB(255, 21, 61, 138),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    left: 35,
                    child: InkWell(
                      onTap: () {
                        _showLocationDropdown(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.locationCrosshairs,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 5),
                              Text(
                                _locationName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            _locationDetails,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -80,
                    right: -260,
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: -260,
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 112,
                    left: 30,
                    right: 30,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _dialogHelper.showDialogContainer(context);
                                        },
                                        child: IgnorePointer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Search",
                                              hintStyle: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 16,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.grey,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -5.5,
                                        left: 110,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: AnimatedTextKit(
                                            animatedTexts: [
                                              RotateAnimatedText(
                                                "Doctor",
                                                textStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 16,
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                              RotateAnimatedText(
                                                "Pharmacy",
                                                textStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 16,
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            ],
                                            repeatForever: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.sliders,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return SettingsPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 28,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ProfilePage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('asset/images/man.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 139,
                    left: 20,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        "asset/gif/test4.gif",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 2,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              "Explore",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Container(
                              height: 190,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color.fromARGB(255, 30, 40, 80)
                                    : Color.fromARGB(255, 235, 240, 230),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 22, 21, 21)
                                              .withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 13,
                                    left: 11,
                                    right: 11,
                                    bottom: 54,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Color.fromARGB(255, 74, 85, 113)
                                            : const Color.fromARGB(
                                                250, 210, 209, 205),
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image:
                                              AssetImage("asset/images/dr.png"),
                                        ),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: const Color.fromARGB(
                                        //             255, 22, 21, 21)
                                        //         .withOpacity(0.2),
                                        //     spreadRadius: 2,
                                        //     blurRadius: 4,
                                        //     offset: Offset(0, 4),
                                        //   ),
                                        // ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Container(
                              height: 190,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color.fromARGB(255, 30, 40, 80)
                                    : Color.fromARGB(255, 235, 240, 230),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 22, 21, 21)
                                              .withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 13,
                                    left: 11,
                                    right: 11,
                                    bottom: 54,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Color.fromARGB(255, 74, 85, 113)
                                            : const Color.fromARGB(
                                                250, 210, 209, 205),
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "asset/images/drugs.png"),
                                        ),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey
                                        //         .withOpacity(0.2),
                                        //     spreadRadius: 4,
                                        //     blurRadius: 5,
                                        //     offset: Offset(0, 4),
                                        //   ),
                                        // ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color.fromARGB(255, 30, 40, 80)
                          : Color.fromARGB(255, 235, 240, 230),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow:
                          Theme.of(context).brightness == Brightness.light
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: Offset(2, 4),
                                  ),
                                ]
                              : [],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 24,
                          left: 18,
                          child: Container(
                            width: 30,
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 52,
                          child: Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          left: 140,
                          child: Container(
                            width: 190,
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 2,
                          right: 20,
                          child: SizedBox(
                            width: 420,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            final _dept = "General Medicine";
                                            showDept(_dept);
                                          },
                                          child: Container(
                                            width: 84,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? null
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                                right: 12,
                                                left: 12,
                                              ),
                                              child: Image.asset(
                                                "asset/images/physician1.png",
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 22,
                                          right: 8,
                                          bottom: 8,
                                        ),
                                        child: Text("Physician"),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            final _dept = "Dermatology";
                                            showDept(_dept);
                                          },
                                          child: Container(
                                            width: 84,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? null
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                                right: 12,
                                                left: 12,
                                              ),
                                              child: Image.asset(
                                                "asset/images/dermatology.png",
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 22,
                                          right: 8,
                                          bottom: 6,
                                        ),
                                        child: Text("Skin-Care"),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            final _dept = "Cardiology";
                                            showDept(_dept);
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? null
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                                right: 12,
                                                left: 12,
                                              ),
                                              child: Image.asset(
                                                "asset/images/cardio.png",
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 22,
                                          right: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          "Cardiology",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 160,
                          left: 2,
                          right: 20,
                          child: SizedBox(
                            width: 420,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            final _dept = "Dentistry";
                                            showDept(_dept);
                                          },
                                          child: Container(
                                            width: 84,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? null
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                                right: 12,
                                                left: 12,
                                              ),
                                              child: Image.asset(
                                                "asset/images/dental-care.png",
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 22,
                                          right: 8,
                                          bottom: 8,
                                        ),
                                        child: Text("Dentistry"),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 20,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            final _dept = "ENT";
                                            showDept(_dept);
                                          },
                                          child: Container(
                                            width: 84,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? null
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                                right: 12,
                                                left: 12,
                                              ),
                                              child: Image.asset(
                                                "asset/images/head.png",
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 26,
                                          right: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          "ENT",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 22,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            showBottomsheet(context);
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? null
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.ellipsis),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 22,
                                          right: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          "More",
                                          textAlign: TextAlign.center,
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: GestureDetector(
                    onTap: () => _fetchAppointmentList(context),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow:
                            Theme.of(context).brightness == Brightness.light
                                ? [
                                    BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: Offset(0, 4),
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ]
                                : [],
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromARGB(255, 30, 40, 80)
                            : Color.fromARGB(255, 235, 240, 230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Container(
                          width: 200,
                          height: 140,
                          color: null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (doctorName != null && doctorName!.isNotEmpty)
                                    ? "Dr ${capitalizeFirst(doctorName!)}"
                                    : "No Appointment",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                specialty ?? "",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                (selectedDate != null &&
                                        selectedDate!.isNotEmpty)
                                    ? "Date: ${formatDate(DateTime.parse(selectedDate!))}"
                                    : "No Date",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                selectedTimeSlot != null
                                    ? "Time: $selectedTimeSlot"
                                    : "No Time",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 8,
                  ),
                  child: CarouselSlider(
                    items: [
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: Offset(4, 6),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://quotefancy.com/media/wallpaper/1600x900/1798715-Bertrand-Russell-Quote-Laughter-is-the-most-inexpensive-and-most.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://quotefancy.com/media/wallpaper/1600x900/46414-Voltaire-Quote-The-art-of-medicine-consists-in-amusing-the-patient.jpg"),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: Offset(4, 6),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: Offset(4, 6),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://quotefancy.com/media/wallpaper/3840x2160/94663-Hippocrates-Quote-Wherever-the-art-of-Medicine-is-loved-there-is.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: Offset(4, 6),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://quotefancy.com/media/wallpaper/1600x900/70576-Charles-Bukowski-Quote-If-you-have-the-ability-to-love-love.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: Offset(4, 6),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://quotefancy.com/media/wallpaper/1600x900/49229-Thomas-Fuller-Quote-Health-is-not-valued-till-sickness-comes.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Color.fromARGB(255, 35, 53, 93),
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Color.fromARGB(255, 35, 53, 93),
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
        unselectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 21, 61, 138),
        ),
        selectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 21, 61, 138),
        ),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userDoctor),
            label: "Doctor",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.camera),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.prescriptionBottleMedical),
            label: "Pharmacy",
          ),
        ],
      ),
    );
  }

  Future<void> showBottomsheet(BuildContext ctx) async {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx1) {
        return Container(
          width: double.infinity,
          height: 500,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color.fromARGB(255, 22, 24, 55)
                : Color.fromARGB(255, 236, 232, 225),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 17, left: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Color.fromARGB(255, 22, 24, 55)
                          : Colors.white,
                      hintText: "Search the category",
                    ),
                  ),
                ),
              ),
              SizedBox(),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final department = departments[index];
                    return Container(
                      margin: EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          final dept = department;
                          showDept(dept);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                'asset/department/$department.png',
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                          title: Text(department),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox();
                  },
                  itemCount: departments.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDept(_dept) async {
    List<Map<String, dynamic>> topDoctors = await _firestore.searchDept(_dept);

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => DepartDoc(dept: _dept, topDoctors: topDoctors),
      ),
    );
  }

  void _showLocationDropdown(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(10, 80, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _fetchLocation();
            },
            child: Text("Get Current Location"),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchAppointmentList(BuildContext context) async {
    print("Fetching appointments...");

    List<Map<String, dynamic>> appointments =
        await _firestore.fetchAppointments();

    // Navigate and pass data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentScreen(appointments: appointments),
      ),
    );
  }

  /// Fetches current location and updates UI
  Future<void> _fetchLocation() async {
    try {
      var locationData = await LocationService.getLatLong();
      setState(() {
        _locationName = locationData["locality"] ?? "Unknown";
        _locationDetails = locationData["address"] ?? "Location not found";
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }
}
