import 'package:flutter/material.dart';
import 'package:flutter_application_4/services/firestore.dart';
import 'package:flutter_application_4/token_generat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorsAppointment extends StatefulWidget {
  final dynamic doctorId;
  final dynamic doctorName;
  final dynamic doctorDept;

  const DoctorsAppointment({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorDept,
  });

  @override
  State<DoctorsAppointment> createState() => _DoctorsAppointmentState();
}

class _DoctorsAppointmentState extends State<DoctorsAppointment> {
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  final FirestoreServices _firestore = FirestoreServices();

  var _myColorTwo;
  var _myColorFive;
  var _myColorOne;
  var _myColorThree;
  var _myColorFour;
  DateTime today = DateTime.now();
  DateTime? selectday;
  List<String> availableDays = [];
  String? selectedSlot; // Store the selected slot

  @override
  void initState() {
    super.initState();
    _fetchAvailableDays();
  }

  Future<void> _fetchAvailableDays() async {
    List<String> days =
        await _firestore.getDoctorAvailableDays(widget.doctorId);
    setState(() {
      print(days); // Debugging: Print fetched days
      availableDays = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 61, 138),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 21, 61, 138),
                        const Color.fromARGB(255, 235, 237, 239)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0),
                      width: 3.0,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 0,
                        child: Container(
                          width: 180,
                          height: 200,
                          decoration: BoxDecoration(
                            color: null,
                            image: DecorationImage(
                              image: AssetImage("asset/images/dr.png"),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60.0,
                        left: 170,
                        child: Text(
                          "Dr ${capitalizeFirst(widget.doctorName ?? 'Unknown')}",
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 95.00,
                        left: 170,
                        child: Text(
                          widget.doctorDept,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: 115.0,
                      //   left: 170,
                      //   child: Text(
                      //     'Upasana Hospital, Kollam',
                      //     style: TextStyle(
                      //       fontSize: 15.0,
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        top: 140,
                        left: 170,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = null;
                                  _myColorThree = null;
                                  _myColorFour = null;
                                  _myColorFive = null;
                                }),
                                child: Icon(
                                  Icons.star,
                                  size: 20,
                                  color: _myColorOne,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = null;
                                  _myColorFour = null;
                                  _myColorFive = null;
                                }),
                                child: Icon(
                                  Icons.star,
                                  size: 20,
                                  color: _myColorTwo,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = Colors.orange;
                                  _myColorFour = null;
                                  _myColorFive = null;
                                }),
                                child: Icon(
                                  Icons.star,
                                  size: 20,
                                  color: _myColorThree,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = Colors.orange;
                                  _myColorFour = Colors.orange;
                                  _myColorFive = null;
                                }),
                                child: Icon(
                                  Icons.star,
                                  size: 20,
                                  color: _myColorFour,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                _myColorOne = Colors.orange;
                                _myColorTwo = Colors.orange;
                                _myColorThree = Colors.orange;
                                _myColorFour = Colors.orange;
                                _myColorFive = Colors.orange;
                              }),
                              child: Icon(
                                Icons.star,
                                size: 20,
                                color: _myColorFive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 216, 212, 212)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatsCard(
                      '100',
                      'Running',
                    ),
                    _buildStatsCard('200', 'Completed'),
                    _buildStatsCard('50', 'Upcoming'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: today,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectday, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectday = selectedDay;
                      print(selectday);
                    });
                    _showAvailableSlots(context, selectedDay);
                  },
                  enabledDayPredicate: (day) {
                    // Disable days before today
                    return !day
                        .isBefore(DateTime(today.year, today.month, today.day));
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      // Check if the day is before the current date
                      if (day.isBefore(
                          DateTime(today.year, today.month, today.day))) {
                        return null; // Do not mark days before today
                      }

                      // Check if the day is in the availableDays list
                      if (availableDays.contains(_getDayOfWeek(day))) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null; // Use default styling for other days
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return '';
    }
  }

  void _showAvailableSlots(BuildContext context, DateTime day) async {
    List<String> slots =
        await _firestore.getAvailableSlots(widget.doctorId, day);
    // ignore: use_build_context_synchronously
    _showSlotDialog(context, slots);
  }

  void _showSlotDialog(BuildContext context, List<String> slots) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempSelectedSlot = selectedSlot; // Temporary state

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text("Appointment"),
                ],
              ),
              content: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: slots.isEmpty
                          ? Center(
                              child: Text(
                                "No available slots",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.all(12),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setDialogState(() {
                                      tempSelectedSlot =
                                          slots[index]; // Update dialog state
                                    });
                                  },
                                  child: Card(
                                    color: tempSelectedSlot == slots[index]
                                        ? Colors.green[100]
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: Colors.blueAccent, width: 1.5),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.access_time,
                                          color: Colors.blue),
                                      title: Text(
                                        slots[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Available",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                    height: 8); // Adds spacing between cards
                              },
                              itemCount: slots.length,
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: selectday != null && tempSelectedSlot != null
                      ? () async {
                          setState(() {
                            selectedSlot = tempSelectedSlot;
                          });

                          final token = await _firestore.bookAppointment(
                              widget.doctorId, selectday!, selectedSlot!);

                          print(token);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return TokenGenerate(token: token);
                              },
                            ),
                          );
                        }
                      : null, // Disable the button if no date or slot is selected
                  child: Text('Book Now'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatsCard(String value, String label) {
    return Container(
      height: 60,
      width: 75.0,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 185, 188, 188),
        border: Border.all(color: const Color.fromARGB(255, 171, 167, 167)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 25),
          ),
          Text(label),
        ],
      ),
    );
  }
}
