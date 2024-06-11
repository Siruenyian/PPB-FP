import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/services/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCommentPage extends StatefulWidget {
  final String bookId;
  final DocumentSnapshot? comment;
  AddCommentPage({required this.bookId, this.comment});

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final CommentService _commentService = CommentService();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.comment != null) {
      _contentController.text = widget.comment!['content'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comment == null ? 'Add Comment' : 'Edit Comment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
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
                  if (widget.comment == null) {
                    // Add new comment
                    await _commentService.addComment(widget.bookId, userId, content);
                  } else {
                    // Update existing comment
                    await _commentService.updateComment(widget.comment!.id, content);
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No user is logged in'),
                    ),
                  );
                }
              },
              child: Text(widget.comment == null ? 'Add Comment' : 'Update Comment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
