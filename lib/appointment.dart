import 'package:flutter/material.dart';
import 'package:flutter_application_4/services/firestore.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;

  AppointmentScreen({super.key, required this.appointments});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final FirestoreServices _firestore = FirestoreServices();
  late List<Map<String, dynamic>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = List.from(widget.appointments);
  }

  void _removeAppointment(String doctorId, String selectedDate) async {
    await _firestore.removeAppointment(doctorId, selectedDate);
    setState(() {
      _appointments.removeWhere((appointment) =>
          appointment['doctorId'] == doctorId &&
          appointment['selectedDate'] == selectedDate);
    });
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Your Appointments",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _appointments.isEmpty
          ? Center(
              child: Text("No Appointments Available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                var appointment = _appointments[index];
                var doctor = appointment['doctorDetails'] ?? {};
                String isoDate = appointment['selectedDate'];
                DateTime parsedDate = DateTime.parse(isoDate);
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(parsedDate);
                String dayName = DateFormat('EEEE').format(parsedDate);
                String timeSlot = appointment['selectedTimeSlot'] ?? '--:--';

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  color: Theme.of(context).cardColor,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage("asset/images/dr.png"),
                              radius: 30,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dr ${capitalizeFirst(doctor['name'] ?? "Unknown")}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  capitalizeFirst(
                                      doctor['speciality'] ?? "General"),
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                            height: 20, thickness: 1, color: Colors.grey[300]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _appointmentDetail("Date", formattedDate, dayName),
                            _appointmentDetail("Time", timeSlot, ""),
                            _appointmentDetail(
                                "Token No",
                                _getShortToken(appointment['token']),
                                appointment['token']),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _removeAppointment(
                                doctor['doctorId'],
                                appointment['selectedDate']),
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _appointmentDetail(String title, String value, String subValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (subValue.isNotEmpty)
          Text(
            subValue,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey[700],
            ),
          ),
      ],
    );
  }

  String _getShortToken(String? fullToken) {
    if (fullToken == null) return '---';
    final parts = fullToken.split('-');
    return (parts.length >= 3) ? '${parts[0]}-${parts[2]}' : fullToken;
  }
}
