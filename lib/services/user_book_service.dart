import 'package:cloud_firestore/cloud_firestore.dart';


class BorrowedBooksService{
  final CollectionReference borrowedbooks = 
    FirebaseFirestore.instance.collection('borrowed_books');
  
  final CollectionReference booksCollection = 
    FirebaseFirestore.instance.collection('books');

  Future<void> addBook(String userUid, String bookUid) {
    return borrowedbooks.add({
      'userUid': userUid,
      'bookUid': bookUid,
      'timestamp': DateTime.now()
    });
  }

  Future<void> removeBook(String userUid, String bookUid) {
    return borrowedbooks.where('userUid', isEqualTo: userUid)
      .where('bookUid', isEqualTo: bookUid).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
  }

  Future<List<DocumentSnapshot>> getBooksByUserID(String userUid) async {

    final borrowedBooksSnapshot = await borrowedbooks.where('userUid', isEqualTo: userUid).get();
    final List<String> bookUids = borrowedBooksSnapshot.docs.map((doc) => doc['bookUid'] as String).toList();

    List<DocumentSnapshot> books = [];
      
    for (String bookUid in bookUids) {
      final bookSnapshot = await booksCollection.doc(bookUid).get();
      if (bookSnapshot.exists) {
        books.add(bookSnapshot);
      }
    }

    return books;
  }

}