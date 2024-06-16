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
  Future<void> deleteBook(String bookUid) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('borrowed_books')
          .where('bookUid', isEqualTo: bookUid)
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return await FirebaseFirestore.instance
          .collection('books_dummy')
          .doc(bookUid)
          .delete();
    } catch (e) {
      // print('Error deleting book: $e');
      throw e;
    }
  }
}
