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

  Stream<QuerySnapshot<Object?>> getBookByTitle(String title) {
      final result = book
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThanOrEqualTo: title + '\uf8ff')
          .snapshots();
      return result;
  }

Future<void> deleteBook(String bookUid) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('borrowed_books')
        .where('bookUid', isEqualTo: bookUid)
        .get();
    
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    } 
    return await FirebaseFirestore.instance.collection('books').doc(bookUid).delete();
  } catch (e) {

    print('Error deleting book: $e');
    throw e;
  }
}


  Stream<QuerySnapshot> getBooksStream(){
    final notesStream = book.snapshots().map((snapshot) {
      return snapshot;
    });

    return notesStream;
  }


}