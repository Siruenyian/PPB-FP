import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final CollectionReference comments = FirebaseFirestore.instance.collection('comments');

  // Create a new comment
  Future<void> addComment(String bookId, String userId, String content) async {
    DocumentReference docRef = await comments.add({
      'book_id': bookId,
      'user_id': userId,
      'content': content,
      'timestamp': Timestamp.now(),
    });

    // Update the document with its ID
    await docRef.update({'id': docRef.id});
  }

  // Get comments for a specific book
  Stream<QuerySnapshot> getCommentsStream(String bookId) {
    return comments
        .where('book_id', isEqualTo: bookId)
        .snapshots();
  }

  // Update a comment
  Future<void> updateComment(String commentId, String newContent) {
    return comments.doc(commentId).update({
      'content': newContent,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete a comment
  Future<void> deleteComment(String commentId) {
    return comments.doc(commentId).delete();
  }
}
