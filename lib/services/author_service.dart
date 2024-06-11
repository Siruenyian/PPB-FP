import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  final CollectionReference author =
      FirebaseFirestore.instance.collection('authors');

  Future<void> addBook(String name, String bio, String age) {
    return author.add({
      'age': age,
      'bio': bio,
      'name': name,
    });
  }

  Future<void> updateBook(
      String authorUid, String name, String bio, String age) {
    return author.doc(authorUid).update({
      'age': age,
      'bio': bio,
      'name': name,
    });
  }

  Future<DocumentSnapshot> getAuthorByID(String authorUid) {
    return author.doc(authorUid).get();
  }

  Future<QuerySnapshot> getAuthorByName(String name) {
    return author.where('name', arrayContains: name).get();
  }

  Future<QuerySnapshot> getAuthorByAge(String age) {
    return author.where('age', arrayContains: age).get();
  }

  Future<void> deleteAuthor(String authorUid) {
    return author.doc(authorUid).delete();
  }

  Stream<QuerySnapshot> getAuthorStream() {
    final authorsStream = author.snapshots().map((snapshot) {
      return snapshot;
    });

    return authorsStream;
  }
}
