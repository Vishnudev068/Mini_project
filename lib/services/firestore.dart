import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_4/global.dart';
import 'package:geolocator/geolocator.dart';

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

          return distanceInKm <= 100.0; // Filter doctors within 100 km
        } catch (e) {
          print('Error calculating distance for doctor ${doc.id}: $e');
          return false;
        }
      }).toList();

      // Sort by rating (higher rating first)
      filteredDocs.sort((a, b) {
        double ratingA = double.tryParse(
                (a.data() as Map<String, dynamic>)['rating']?.toString() ??
                    '0.0') ??
            0.0;
        double ratingB = double.tryParse(
                (b.data() as Map<String, dynamic>)['rating']?.toString() ??
                    '0.0') ??
            0.0;

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

    // Ensure user location is available
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
        .map((snapshot) {
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

          return distanceInKm <= 30.0; // Filter doctors within 100 km
        } catch (e) {
          print('Error calculating distance for doctor ${doc.id}: $e');
          return false;
        }
      }).toList();

      return filteredDocs;
    });
  }
}
