import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('books_dummy');

  // C
  Future<void> addBook(
      String title, String coverImg, String description, String authorId) {
    return notes.add({
      'title': title,
      'cover_url': coverImg,
      'description': description,
      'author_id': authorId,
      'timestamp': Timestamp.now(),
    });
  }

  // R
  Stream<QuerySnapshot> getBooksStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // U
  Future<void> updateBook(String docID, String title, String coverImg,
      String description, String authorId) {
    return notes.doc(docID).update({
      'title': title,
      'cover_url': coverImg,
      'description': description,
      'author_id': authorId,
      'timestamp': Timestamp.now(),
    });
  }

  // D
  Future<void> deleteBook(String docID) {
    return notes.doc(docID).delete();
  }
}
