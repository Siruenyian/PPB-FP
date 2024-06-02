import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/services/comments.dart';

class AddCommentPage extends StatefulWidget {
  final String bookId;

  AddCommentPage({required this.bookId});

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final CommentService _commentService = CommentService();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String userId = user.uid;
                  String content = _contentController.text;
                  await _commentService.addComment(widget.bookId, userId, content);
                  Navigator.pop(context);
                } else {
                  // Handle the case when there is no logged-in user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No user is logged in'),
                    ),
                  );
                }
              },
              child: Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
