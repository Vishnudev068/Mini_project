import 'package:flutter/material.dart';
import 'package:flutter_application_4/doctor_info.dart';
import 'package:flutter_application_4/services/firestore.dart';

class DepartDoc extends StatefulWidget {
  final String dept;
  final List<Map<String, dynamic>> topDoctors;
  DepartDoc({Key? key, required this.dept, required this.topDoctors})
      : super(key: key);

  @override
  State<DepartDoc> createState() => _DepartDocState();
}

class _DepartDocState extends State<DepartDoc> {
  final FirestoreServices _firestore = FirestoreServices();
  var searchQuery = "";
  final Map<int, ValueNotifier<bool>> _favoriteNotifiers = {};

  final Map<String, String> departmentDetails = {
    "Physician": "General medical care, diagnosis, and treatment of illnesses.",
    "Cardiology": "Heart-related diseases, diagnosis, and treatment.",
    "Neurology": "Brain, spinal cord, and nervous system disorders.",
    "Orthopedics": "Bone, joint, and muscle disorders and surgeries.",
    "Gastroenterology": "Digestive system diseases and conditions.",
    "Oncology": "Diagnosis and treatment of various cancers.",
    "Nephrology": "Kidney diseases and their treatments.",
    "Pulmonology": "Lung and respiratory system disorders.",
    "Endocrinology": "Hormonal imbalances and gland disorders.",
    "Pediatrics": "Medical care for infants, children, and adolescents.",
    "Gynecology & Obstetrics": "Women's reproductive health and childbirth.",
    "Dermatology": "Skin, hair, and nail disorders and treatments.",
    "Ophthalmology": "Eye disorders, surgeries, and vision correction.",
    "Urology": "Urinary tract and male reproductive system diseases.",
    "Psychiatry": "Mental health disorders and psychological treatments.",
    "Radiology": "Medical imaging for diagnosis (X-rays, MRI, CT scans).",
    "Anesthesiology": "Pain management and anesthesia for surgeries.",
    "Emergency Medicine": "Urgent care for critical medical conditions.",
    "Rheumatology": "Arthritis and autoimmune joint disorders.",
    "Hematology": "Blood disorders, anemia, and clotting diseases.",
    "Surgeon": "Performs surgical procedures for various conditions.",
    "ENT": "Ear, nose, and throat diseases and treatments.",
    "Dentistry": "Oral health, teeth, and gum-related care.",
  };

  @override
  Widget build(BuildContext context) {
    String deptDetails =
        departmentDetails[widget.dept] ?? "No details available";

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 8,
            top: 28,
          ),
          child: Text('Department Details'),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 20,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.dept,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 8,
                    bottom: 2,
                  ),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset("asset/department/${widget.dept}.png"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              deptDetails,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              indent: 10,
              endIndent: 10,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: SizedBox(
                height: 50,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Color.fromARGB(255, 22, 24, 55)
                        : Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Doctors",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: searchQuery.isEmpty
                  ? buildInfoWidget(widget.topDoctors)
                  : StreamBuilder(
                      stream: _firestore.getDeptDoc(widget.dept, searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No doctors found"));
                        }
                        var docs = snapshot.data!.docs;
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var data =
                                docs[index].data() as Map<String, dynamic>;
                            _favoriteNotifiers[index] ??=
                                ValueNotifier<bool>(false);
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 20,
                                bottom: 10,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 236,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Theme.of(context).brightness == Brightness.dark
                                  //     ? Border.all(
                                  //         color:
                                  //             Theme.of(context).colorScheme.onBackground,
                                  //         width: 2,
                                  //       )
                                  //     : null,
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
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: AssetImage(
                                                    'asset/images/doctor1.jpg'),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['name'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.dept,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.star,
                                                      color: Colors.amber),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "4.6",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  size: 18, color: Colors.blue),
                                              SizedBox(width: 8),
                                              Text(
                                                'Mon, 23 Oct 2023',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
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
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 0, 150, 136),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'View Details',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            _favoriteNotifiers[index]!.value =
                                                !_favoriteNotifiers[index]!
                                                    .value;
                                          },
                                          child: ValueListenableBuilder<bool>(
                                            valueListenable:
                                                _favoriteNotifiers[index]!,
                                            builder: (context, isRed, child) {
                                              return Icon(
                                                Icons.favorite,
                                                size: 20,
                                                color: isRed
                                                    ? Colors.red
                                                    : Colors.grey,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: docs.length,
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoWidget(List<Map<String, dynamic>> doctors) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        _favoriteNotifiers[index] ??= ValueNotifier<bool>(false);
        var data = doctors[index];

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 20, bottom: 10),
          child: Container(
            width: double.infinity,
            height: 236,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: Theme.of(context).brightness == Brightness.light
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
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage('asset/images/doctor1.jpg'),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['department'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
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
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Mon, 23 Oct 2023',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            '10:00 AM - 11:00 AM',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            String doctorId = data['id'];
                            Map<String, dynamic>? doctorData =
                                await _firestore.fetchDoctorData(doctorId);

                            if (doctorData != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorInfo(doctorData: doctorData),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Doctor not found!")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 0, 150, 136),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "View Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _favoriteNotifiers[index]!.value =
                            !_favoriteNotifiers[index]!.value;
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _favoriteNotifiers[index]!,
                        builder: (context, isRed, child) {
                          return Icon(
                            Icons.favorite,
                            size: 20,
                            color: isRed ? Colors.red : Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemCount: doctors.length,
    );
  }
}
