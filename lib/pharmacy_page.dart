import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/api/api_services.dart';
import 'package:flutter_application_4/functions/db_functions.dart';
import 'package:flutter_application_4/models/models.dart';
import 'package:flutter_application_4/pharmacy_info.dart';
import 'package:flutter_application_4/services/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String searchQuery = "";
  FocusNode _focus = FocusNode();
  final FirestoreServices _firestore = FirestoreServices();
  final TextEditingController _controller = TextEditingController();
  bool _isFocus = false;
  final bool isOpen = true;
  Map<int, bool> expandedItems = {};

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
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
              width: 362.86,
              height: 56,
              child: Stack(
                children: [
                  TextField(
                    focusNode: _focus,
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: null,
                      prefixIcon: Icon(Icons.search_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
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
                                "Search Pharmacy Around",
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
          SizedBox(height: 40),
          Expanded(
            child: searchQuery.isEmpty
                ? Center(
                    child: buildInfoWidget(),
                  )
                : StreamBuilder<List<QueryDocumentSnapshot>>(
                    stream: _firestore.getPharmacy(searchQuery),
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
                        itemBuilder: (context, index) {
                          var data = docs[index].data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 351,
                              height: 190,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color.fromARGB(255, 30, 40, 80)
                                    : const Color.fromARGB(255, 245, 250, 242),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Stack(
                                children: [
                                  // Image
                                  Positioned(
                                    top: 18,
                                    left: 20,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "asset/images/pharmacy.jpg"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Pharmacy Details
                                  Positioned(
                                    top: 22,
                                    left: 132,
                                    child: SizedBox(
                                      width: 185,
                                      height: 120,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            capitalizeFirst(data['name']),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              const FaIcon(
                                                  FontAwesomeIcons
                                                      .locationCrosshairs,
                                                  size: 18),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  data['address']
                                                      .split('\n')[0],
                                                  overflow: TextOverflow
                                                      .ellipsis, // Prevents overflow
                                                  maxLines:
                                                      1, // Limits to a single line
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Click Here Button
                                  Positioned(
                                    top: 130,
                                    right: 20,
                                    child: InkWell(
                                      onTap: () async {
                                        String pharmId = data['id'];
                                        Map<String, dynamic>? pharmData =
                                            await _firestore
                                                .fetchPharmacyData(pharmId);

                                        if (pharmData != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PharmacyInfo(
                                                      pharmData: pharmData),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 0, 150, 136),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Click here",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Rating
                                  const Positioned(
                                    top: 40,
                                    right: 40,
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber),
                                        SizedBox(width: 4),
                                        Text(
                                          "4.6",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Availability Indicator
                                  Positioned(
                                    top: 130,
                                    left: 20,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            isOpen ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isOpen ? "Open Now" : "Closed",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: docs.length,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_pharmacy, size: 60, color: Colors.blue),
            const SizedBox(height: 10),
            const Text(
              "Search for pharmacies around you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
