import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/services/comments.dart';
import 'package:ppb_fp/pages/user/add_comment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommentsPage extends StatefulWidget {
  final String bookId;
  CommentsPage({required this.bookId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final CommentService _commentService = CommentService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('d MMMM yyyy, HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _commentService.getCommentsStream(widget.bookId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final comments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var comment = comments[index];
              return ListTile(
                title: Text(comment['content']),
                subtitle: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(comment['user_id']).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    if (userSnapshot.hasError || !userSnapshot.hasData) {
                      return Text('Unknown user');
                    }
                    var userData = userSnapshot.data!;
                    return Text(
                      '${userData['email']} \n${formatDate(comment['timestamp'])}',
                    );
                  },
                ),
                trailing: comment['user_id'] == currentUser?.uid
                    ? PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCommentPage(
                            bookId: widget.bookId,
                            comment: comment, // Pass the comment for editing
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      await _commentService.deleteComment(comment.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCommentPage(bookId: widget.bookId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
