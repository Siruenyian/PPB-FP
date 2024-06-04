import 'package:cloud_firestore/cloud_firestore.dart';


class BookService{
  final CollectionReference book = 
    FirebaseFirestore.instance.collection('books');

  Future<void> addBook(String title, String coverUrl, String authorUid, String description) {
    return book.add({
      'title': title,
      'cover_url': coverUrl,
      'author_id': authorUid,
      'description': description,
      'timestamp': DateTime.now()
    });
  }

  Future<void> updateBook(String bookUid, String title, String coverUrl, String authorUid, String description) {
    return book.doc(bookUid).update({
      'title': title,
      'cover_url': coverUrl,
      'author_id': authorUid,
      'description': description,
      'timestamp': DateTime.now()
    });
  }
  
  Future<DocumentSnapshot> getBookByID(String bookUid){
    return book.doc(bookUid).get();
  }

  Future<QuerySnapshot> getBookByTitle(String title){
    return book.where('title', arrayContains: title).get();
  }

  Future<void> deleteBook(String bookUid){
    return book.doc(bookUid).delete();
  }

  Stream<QuerySnapshot> getBooksStream(){
    final notesStream = book.snapshots().map((snapshot) {
      return snapshot;
    });

    return notesStream;
  }


}