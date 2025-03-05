import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/doctor_info.dart';
import 'package:flutter_application_4/doctors_appointment.dart';
import 'package:flutter_application_4/services/firestore.dart';
import 'package:intl/intl.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String searchQuery = "";
  final FirestoreServices _firestore = FirestoreServices();
  FocusNode _focus = FocusNode();
  bool _isFocus = false;
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Map<int, bool> expandedItems = {};
  final Map<int, ValueNotifier<bool>> _favoriteNotifiers = {};

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() {
        _isFocus = _focus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, d MMMM y').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: SizedBox(
                width: 362.86,
                height: 56,
                child: Stack(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.trim().toLowerCase();
                        });
                      },
                      focusNode: _focus,
                      decoration: InputDecoration(
                        hintText: null,
                        prefixIcon: Icon(Icons.search_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Color.fromARGB(255, 22, 24, 55)
                                : Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 60,
                      top: 16,
                      child: _isFocus
                          ? Container()
                          : AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText(
                                  "Search doctor Around",
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  speed: Duration(milliseconds: 100),
                                ),
                              ],
                              repeatForever: true,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: searchQuery.isEmpty
                ? Center(child: Text("Type to search..."))
                : StreamBuilder<List<QueryDocumentSnapshot>>(
                    stream: _firestore.getList(searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text("No results found"),
                        );
                      }

                      var docs = snapshot.data!;
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var data = docs[index].data() as Map<String, dynamic>;
                          _favoriteNotifiers[index] ??=
                              ValueNotifier<bool>(false);
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 26,
                              right: 26,
                              bottom: 10,
                            ),
                            child: Container(
                              width: 320,
                              height: 220,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 18,
                                    left: 20,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                          'asset/images/doctor1.jpg'),
                                    ),
                                  ),
                                  Positioned(
                                    top: 18,
                                    left: 292,
                                    child: GestureDetector(
                                      onTap: () {
                                        _favoriteNotifiers[index]!.value =
                                            !_favoriteNotifiers[index]!.value;
                                      },
                                      child: ValueListenableBuilder<bool>(
                                        valueListenable:
                                            _favoriteNotifiers[index]!,
                                        builder: (context, isRed, child) {
                                          return SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.favorite,
                                              size: 20,
                                              color: isRed
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    left: 116,
                                    child: SizedBox(
                                      width: 185,
                                      height: 80,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 4,
                                            child: Text(
                                              "Dr ${capitalizeFirst(data['name'])}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 30,
                                            left: 4,
                                            child: Text(
                                              capitalizeFirst(
                                                data['speciality'].trim(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 80,
                                    left: 260,
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber),
                                        SizedBox(width: 4),
                                        Text(
                                          "${data['rating']}",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 110,
                                    left: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.calendar_today,
                                                size: 18, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.access_time,
                                                size: 18, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text(
                                              '10:00 AM - 11:00 AM',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 170,
                                    right: 25,
                                    bottom: 12,
                                    child: SizedBox(
                                      width: 140,
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          String doctorId = data['doctorId'];
                                          Map<String, dynamic>? doctorData =
                                              await _firestore
                                                  .fetchDoctorData(doctorId);

                                          if (doctorData != null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorInfo(
                                                        doctorData: doctorData),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Doctor not found!")),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 0, 150, 136),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          "View Details",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemCount: docs.length,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
