import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/services/comments.dart';
import 'package:ppb_fp/pages/user/add_comment_page.dart';

class CommentsPage extends StatefulWidget {
  final String bookId;

  CommentsPage({required this.bookId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final CommentService _commentService = CommentService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
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
                      ' ${userData['email']} \n ${comment['timestamp']?.toDate() ?? 'Unknown'}',
                    );
                  },
                ),
                trailing: comment['user_id'] == currentUser?.uid ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Implement edit comment functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _commentService.deleteComment(comment.id);
                      },
                    ),
                  ],
                ) : null,
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
      ),
    );
  }
}
