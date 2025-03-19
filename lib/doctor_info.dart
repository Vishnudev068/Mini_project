import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/doctors_appointment.dart';
import 'package:flutter_application_4/map.dart';
import 'package:flutter_application_4/offline_page.dart';
import 'package:flutter_application_4/token_generat.dart';
import 'package:latlong2/latlong.dart';

class DoctorInfo extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorInfo({super.key, required this.doctorData});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  bool _isRed = false;
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color.fromARGB(255, 74, 85, 113)
                          : Colors.grey,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset("asset/images/dr.png"),
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
                          color: Colors.black.withOpacity(0.2),
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
                  right: 24,
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
                          color: Colors.black.withOpacity(0.2),
                          child: Icon(
                            Icons.bookmark,
                            size: 20,
                            color: _isRed ? Colors.amber : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: null,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 28),
                    child: Text(
                      "Dr ${capitalizeFirst(widget.doctorData['name'] ?? 'Unknown')}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 64, left: 28),
                    child: Text(
                      capitalizeFirst(widget.doctorData['speciality']),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 28,
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          "${widget.doctorData['rating']}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 20,
                    bottom: 10,
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildInfoColumn(
                            "Experience", "${widget.doctorData['experience']}"),
                      ),
                      Container(
                        width: 2,
                        height: 50,
                        color: Colors.blue,
                      ),
                      Expanded(
                        child: _buildInfoColumn("Availability",
                            "${widget.doctorData['availability']}"),
                      ),
                      Container(
                        width: 2,
                        height: 50,
                        color: Colors.blue,
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                            "Rating", "${widget.doctorData['rating']}"),
                      ),
                    ],
                  ),
                ),
                _buildSection("About Doctor", "${widget.doctorData['about']}"),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 20,
                    right: 2,
                    bottom: 4,
                  ),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                _buildSection(
                  "Achievements",
                  widget.doctorData['achievements']
                      .map((achievements) => "• $achievements")
                      .join("\n"),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 20,
                    right: 2,
                    bottom: 4,
                  ),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                _buildSection(
                  "Services",
                  widget.doctorData['services']
                      .map((service) => "• $service")
                      .join("\n"),
                ),
                // Padding(
                //   padding: EdgeInsets.all(8),
                //   child: Container(
                //     width: 200,
                //     height: 200,
                //     color: Colors.red,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).navigationBarTheme.backgroundColor,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MapScreen(
                          location: LatLng(
                            widget.doctorData['location']['latitude'],
                            widget.doctorData['location']['longitude'],
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  "Get location",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 80,
                right: 20,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: widget.doctorData['availability'] == "No"
                      ? Colors.grey
                      : Colors.blueAccent,
                ),
                onPressed: widget.doctorData['availability'] == "No"
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DoctorsAppointment(
                                doctorId: widget.doctorData['doctorId'],
                                doctorName:
                                    widget.doctorData['name'] ?? "Unknown",
                                doctorDept: widget.doctorData['speciality'] ??
                                    "genaral",
                              );
                            },
                          ),
                        );
                      },
                child: Text(
                  'View Details',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
