import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
 
  // Future<void> addNote(String note) {
  //   return notes.add({'note': note, 'time': Timestamp.now()});
  // }
  // Stream<QueryDocumentSnapshot> getList(){

     
    
  // }

  Stream<QuerySnapshot> getList(String prefix) {
  return FirebaseFirestore.instance
      .collection('doctors') // Replace with your Firestore collection
      .where('name', isGreaterThanOrEqualTo: prefix)
      .where('name', isLessThan: prefix + '\uf8ff') // Ensures prefix filtering
      .snapshots();
}

}
