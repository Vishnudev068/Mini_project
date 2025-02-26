import 'package:flutter/material.dart';
import 'package:flutter_application_4/token_generat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorsAppointment extends StatefulWidget {
  const DoctorsAppointment({super.key});

  @override
  State<DoctorsAppointment> createState() => _DoctorsAppointmentState();
}

class _DoctorsAppointmentState extends State<DoctorsAppointment> {
  var _myColorTwo;
  var _myColorFive;
  var _myColorOne;
  var _myColorThree;
  var _myColorFour;
  DateTime today = DateTime.now();
  DateTime? selectday;

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
                        child: const Text(
                          'Dr name',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 95.00,
                        left: 170,
                        child: const Text(
                          'MBBS MD',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 115.0,
                        left: 170,
                        child: const Text(
                          'Upasana Hospital, Kollam',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
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
                    selectedDay = selectedDay;
                  });
                  _showAvailableslot(context, selectedDay);
                },
              )),
            )
          ],
        ),
      ),
    );
  }

  void _showAvailableslot(BuildContext context, DateTime selectDay) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
              Text("appoinment")
            ]),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("slot $index"),
                            trailing: Text("booked"),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: 10),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return TokenGenerate();
                  }));
                },
                child: Text('book now'),
              ),
            ],
          );
        });
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
