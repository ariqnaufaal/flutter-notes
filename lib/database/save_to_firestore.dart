import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference notes = FirebaseFirestore.instance.collection('Notes');

  // create new note
  Future<void> createNote(String title, String content) {
    return notes.add({
      'userEmail': user!.email,
      'title': title,
      'content': content,
      'category': '',
      'imagePath': '',
      'audioPath': '',
      'sketchPath': '',
      'modifiedTime': Timestamp.now(),
    });
  }

  // read notes of current user from database
  Stream<QuerySnapshot> getNotesStream(String userEmail) {
    final notesStream = FirebaseFirestore.instance
      .collection('Notes')
      .where('userEmail', isEqualTo: userEmail)
      .orderBy('modifiedTime', descending: true)
      .snapshots();

    return notesStream;
  }
}