import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<QueryDocumentSnapshot>> getList(String prefix) {
    if (prefix.isEmpty) {
      return Stream.value([]);
    }

    var nameQuery = firestore
        .collection('doctors')
        .where('name', isGreaterThanOrEqualTo: prefix)
        .where('name', isLessThan: prefix + '\uf8ff')
        .snapshots();

    var departmentQuery = firestore
        .collection('doctors')
        .where('speciality', isGreaterThanOrEqualTo: prefix)
        .where('speciality', isLessThan: prefix + '\uf8ff')
        .snapshots();

    return nameQuery.asyncMap(
      (nameSnapshot) async {
        var departmentSnapshot = await departmentQuery.first;
        var mergedDocs = [...nameSnapshot.docs, ...departmentSnapshot.docs];
        mergedDocs.sort((a, b) {
          double ratingA = double.tryParse(
                  (a.data() as Map<String, dynamic>)['rating']?.toString() ??
                      '0.0') ??
              0.0;
          double ratingB = double.tryParse(
                  (b.data() as Map<String, dynamic>)['rating']?.toString() ??
                      '0.0') ??
              0.0;
          return ratingB.compareTo(ratingA); // Higher rating first
        });

        return mergedDocs;
      },
    );
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

  Stream<QuerySnapshot> getDeptDoc(String dept, String prefix) {
    dept = dept.trim().toLowerCase();

    return firestore
        .collection('doctors')
        .where('speciality', isEqualTo: dept)
        .where('name', isGreaterThanOrEqualTo: prefix)
        .where('name', isLessThanOrEqualTo: '$prefix\uf8ff')
        .snapshots();
  }
}
