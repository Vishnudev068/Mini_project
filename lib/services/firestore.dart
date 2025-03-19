import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_4/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class FirestoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<QueryDocumentSnapshot>> getList(String prefix) {
    if (prefix.isEmpty) {
      return Stream.value([]);
    }

    // Ensure user location is available
    double? userLatitude = globalLatitude;
    double? userLongitude = globalLongitude;

    if (userLatitude == null || userLongitude == null) {
      throw Exception(
          'User location is not available. Please enable location services.');
    }

    var nameQuery = firestore
        .collection('doctors')
        .where('name', isGreaterThanOrEqualTo: prefix)
        .where('name', isLessThan: prefix + '\uf8ff')
        .snapshots();

    return nameQuery.map((snapshot) {
      var filteredDocs = snapshot.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>?;

        var location = data?['location'];
        if (location == null) return false;

        double? doctorLatitude = location['latitude'];
        double? doctorLongitude = location['longitude'];

        if (doctorLatitude == null || doctorLongitude == null) return false;

        try {
          double distanceInKm = Geolocator.distanceBetween(
                userLatitude,
                userLongitude,
                doctorLatitude,
                doctorLongitude,
              ) /
              1000;

          return distanceInKm <= 30.0;
        } catch (e) {
          print('Error calculating distance for doctor ${doc.id}: $e');
          return false;
        }
      }).toList();

      // Sort by rating (higher rating first)
      filteredDocs.sort((a, b) {
        double ratingA =
            double.tryParse((a.data())['rating']?.toString() ?? '0.0') ?? 0.0;
        double ratingB =
            double.tryParse((b.data())['rating']?.toString() ?? '0.0') ?? 0.0;

        return ratingB.compareTo(ratingA);
      });

      return filteredDocs;
    });
  }

  Future<Map<String, dynamic>?> fetchDoctorData(String doctorId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where("doctorId", isEqualTo: doctorId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching doctor: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchDept(String dept) async {
    try {
      dept = dept.trim().toLowerCase();
      QuerySnapshot querySnapshot = await firestore
          .collection('doctors')
          .where('speciality', isEqualTo: dept)
          .orderBy('rating', descending: true)
          .limit(3)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching top doctors: $e");
      return [];
    }
  }

  Stream<List<QueryDocumentSnapshot>> getDeptDoc(String dept, String prefix) {
    dept = dept.trim().toLowerCase();

    double? userLatitude = globalLatitude;
    double? userLongitude = globalLongitude;

    if (userLatitude == null || userLongitude == null) {
      throw Exception(
          'User location is not available. Please enable location services.');
    }

    return firestore
        .collection('doctors')
        .where('speciality', isEqualTo: dept)
        .where('name', isGreaterThanOrEqualTo: prefix)
        .where('name', isLessThanOrEqualTo: '$prefix\uf8ff')
        .snapshots()
        .map(
      (snapshot) {
        var filteredDocs = snapshot.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>?;

          var location = data?['location'];
          if (location == null) return false;

          double? doctorLatitude = location['latitude'];
          double? doctorLongitude = location['longitude'];

          if (doctorLatitude == null || doctorLongitude == null) return false;

          try {
            double distanceInKm = Geolocator.distanceBetween(
                  userLatitude,
                  userLongitude,
                  doctorLatitude,
                  doctorLongitude,
                ) /
                1000;

            return distanceInKm <= 30.0;
          } catch (e) {
            print('Error calculating distance for doctor ${doc.id}: $e');
            return false;
          }
        }).toList();

        return filteredDocs;
      },
    );
  }

  Future<List<String>> getAvailableSlots(String doctorId, DateTime day) async {
    String weekday = _getWeekday(day);

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('appointment')
          .where('doctorId', isEqualTo: doctorId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null &&
            data["availability"] != null &&
            data["availability"].containsKey(weekday)) {
          List<dynamic> slots =
              data["availability"][weekday]["timeSlots"] ?? [];
          return List<String>.from(slots);
        }
      }
    } catch (e) {
      print("Error fetching slots: $e");
    }

    return [];
  }

  String _getWeekday(DateTime date) {
    List<String> weekdays = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday"
    ];
    return weekdays[date.weekday - 1];
  }

  Future<List<String>> getDoctorAvailableDays(String doctorId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('appointment')
          .where('doctorId', isEqualTo: doctorId)
          .limit(1) // Assuming one document per doctor
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey("availability")) {
          return data["availability"].keys.toList();
        }
      }
    } catch (e) {
      print("Error fetching available days: $e");
    }
    return [];
  }

  Future<String> bookAppointment(
      String doctorId, DateTime selectedDate, String selectedSlot) async {
    try {
      String? userId = GlobalState().getUserId();

      if (userId == null) {
        throw Exception("User ID is null. Please log in again.");
      }

      String token = generateToken(doctorId, selectedDate, userId);

      CollectionReference usersRef = firestore.collection('bookings');
      QuerySnapshot querySnapshot =
          await usersRef.where("userId", isEqualTo: userId).limit(1).get();

      Map<String, dynamic> appointment = {
        "doctorId": doctorId,
        "timestamp": DateTime.now().toIso8601String(),
        "selectedDate": selectedDate.toIso8601String(),
        "selectedTimeSlot": selectedSlot,
        "token": token
      };

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = querySnapshot.docs.first.reference;
        await userDocRef.update({
          "appointments": FieldValue.arrayUnion([appointment])
        });
      } else {
        await usersRef.add({
          "userId": userId,
          "appointments": [appointment]
        });
      }

      return token;
    } catch (e) {
      print("❌ Error booking appointment: $e");
      return "Error";
    }
  }

  Stream<List<Map<String, dynamic>>> getPharmaciesWithMedicine(
      String medicineName) {
    if (medicineName.isEmpty) {
      print("⚠️ Medicine name is empty. Returning empty list.");
      return Stream.value([]);
    }

    print("🔍 Searching for medicine: $medicineName in all pharmacies...");

    return firestore.collection('pharmacy').snapshots().map((snapshot) {
      var matchedPharmacies = snapshot.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('medicines')) {
          print("⚠️ Skipping pharmacy ${doc.id}, no medicines data.");
          return false;
        }

        List<dynamic> medicines = data['medicines'];
        bool medicineFound = medicines.any((med) {
          String medName = (med['name'] as String).trim().toLowerCase();
          String searchName = medicineName.trim().toLowerCase();
          return medName == searchName || medName.contains(searchName);
        });

        return medicineFound;
      }).map((doc) {
        var data = doc.data();

        List<Map<String, dynamic>> availableMedicines =
            (data['medicines'] as List<dynamic>)
                .where((med) => (med['name'] as String)
                    .trim()
                    .toLowerCase()
                    .contains(medicineName.trim().toLowerCase()))
                .map((med) => {
                      'name': med['name'],
                      'price': med['price'],
                    })
                .toList();

        return {
          'id': doc.id,
          'name': data['name'],
          'address': data['address'],
          'phone': data['phone'],
          'availability': data['availability'],
          'medicines': availableMedicines,
        };
      }).toList();

      print(
          "✅ Found ${matchedPharmacies.length} pharmacies with medicine: $medicineName");
      return matchedPharmacies;
    });
  }

  Future<Map<String, dynamic>?> getLatestAppointment(String userId) async {
    print("hello");
    try {
      QuerySnapshot userSnapshot = await firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        List<dynamic> appointments = userData['appointments'] ?? [];

        if (appointments.isNotEmpty) {
          return appointments.last; // Return latest appointment
        }
      }
    } catch (e) {
      print("Error fetching appointment: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDoctorDetails(String doctorId) async {
    try {
      QuerySnapshot doctorSnapshot = await firestore
          .collection('doctors')
          .where('doctorId', isEqualTo: doctorId) // Match doctorId field
          .limit(1)
          .get();

      if (doctorSnapshot.docs.isNotEmpty) {
        return doctorSnapshot.docs.first.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching doctor details: $e");
    }
    return null;
  }

  Stream<List<QueryDocumentSnapshot>> getPharmacy(String prefix) {
    if (prefix.isEmpty) {
      return Stream.value([]);
    }

    // Ensure user location is available
    double? userLatitude = globalLatitude;
    double? userLongitude = globalLongitude;

    if (userLatitude == null || userLongitude == null) {
      throw Exception(
          'User location is not available. Please enable location services.');
    }

    var nameQuery = firestore
        .collection('pharmacy')
        .where('name', isGreaterThanOrEqualTo: prefix)
        .where('name', isLessThan: prefix + '\uf8ff')
        .snapshots();

    return nameQuery.map((snapshot) {
      var filteredDocs = snapshot.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>?;

        var location = data?['location'];
        if (location == null) return false;

        double? doctorLatitude = location['latitude'];
        double? doctorLongitude = location['longitude'];

        if (doctorLatitude == null || doctorLongitude == null) return false;

        try {
          double distanceInKm = Geolocator.distanceBetween(
                userLatitude,
                userLongitude,
                doctorLatitude,
                doctorLongitude,
              ) /
              1000;

          return distanceInKm <= 30.0;
        } catch (e) {
          print('Error calculating distance for doctor ${doc.id}: $e');
          return false;
        }
      }).toList();

      // Sort by rating (higher rating first)
      filteredDocs.sort((a, b) {
        double ratingA =
            double.tryParse((a.data())['rating']?.toString() ?? '0.0') ?? 0.0;
        double ratingB =
            double.tryParse((b.data())['rating']?.toString() ?? '0.0') ?? 0.0;

        return ratingB.compareTo(ratingA);
      });

      return filteredDocs;
    });
  }

  Future<Map<String, dynamic>?> fetchPharmacyData(String pharmId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pharmacy')
          .where("id", isEqualTo: pharmId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching doctor: $e");
      return null;
    }
  }
}

String generateToken(String doctorId, DateTime date, String userId) {
  final random = Random();
  int randomNumber =
      random.nextInt(9000) + 1000; // Generate a 4-digit random number

  String formattedDate =
      DateFormat('yyyyMMdd').format(date); // Convert DateTime to "YYYYMMDD"

  return "${doctorId.substring(0, 3).toUpperCase()}-$formattedDate-$randomNumber";
}
