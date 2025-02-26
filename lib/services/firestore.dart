import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Future<void> addNote(String note) {
    return notes.add({
      'note':note,
      'time':Timestamp.now()
    });
  }
}
