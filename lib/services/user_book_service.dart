import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowedBooksService {
  final CollectionReference borrowedbooks =
      FirebaseFirestore.instance.collection('borrowed_books');

  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  Future<void> addBook(String userUid, String bookUid) async {
    // Check if the book is already borrowed
    final isBorrowed = await isBookBorrowed(userUid, bookUid);
    if (isBorrowed) {
      throw Exception('Book is already borrowed');
    }

    // If the book is not already borrowed, add it to the borrowed books collection
    await borrowedbooks.add(
        {'userUid': userUid, 'bookUid': bookUid, 'timestamp': DateTime.now()});
  }

  Future<void> removeBook(String userUid, String bookUid) {
    return borrowedbooks
        .where('userUid', isEqualTo: userUid)
        .where('bookUid', isEqualTo: bookUid)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<List<DocumentSnapshot>> getBooksByUserID(String userUid) async {
    final borrowedBooksSnapshot =
        await borrowedbooks.where('userUid', isEqualTo: userUid).get();
    final List<String> bookUids = borrowedBooksSnapshot.docs
        .map((doc) => doc['bookUid'] as String)
        .toList();

    List<DocumentSnapshot> books = [];

    for (String bookUid in bookUids) {
      final bookSnapshot = await booksCollection.doc(bookUid).get();
      if (bookSnapshot.exists) {
        books.add(bookSnapshot);
      }
    }

    return books;
  }

  Future<int> getTotalExpiredBooks() async {
    try {
      final now = DateTime.now();
      final expiredDate = now.subtract(Duration(minutes: 5));

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('borrowed_books')
          .where('timestamp', isLessThan: expiredDate)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting expired books: $e');
      throw e;
    }
  }

  Future<void> deleteAllExpiredBooks() async {
    try {
      final now = DateTime.now();
      final expiredDate = now.subtract(const Duration(minutes: 5));

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('borrowed_books')
          .where('timestamp', isLessThan: expiredDate)
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting expired books: $e');
      throw e;
    }
  }

  Future<bool> isBookBorrowed(String userUid, String bookUid) async {
    final snapshot = await borrowedbooks
        .where('userUid', isEqualTo: userUid)
        .where('bookUid', isEqualTo: bookUid)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
