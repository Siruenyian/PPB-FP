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

  Future<String> _getUsername(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['username'];
  }

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
              return FutureBuilder<String>(
                future: _getUsername(comment['user_id']),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(comment['content']),
                      subtitle: Text('Loading user...'),
                    );
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text(comment['content']),
                      subtitle: Text('Error loading user'),
                    );
                  }
                  return ListTile(
                    title: Text(comment['content']),
                    subtitle: Text(
                      'User: ${userSnapshot.data} \nTime: ${comment['timestamp']?.toDate() ?? 'Unknown'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement update comment functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _commentService.deleteComment(comment.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
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
