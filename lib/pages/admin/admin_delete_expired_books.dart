import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/services/book_service.dart';

class AdminExpiredBooks extends StatefulWidget {
  const AdminExpiredBooks({super.key});

  @override
  State<AdminExpiredBooks> createState() => _AdminExpiredBooksState();
}

class _AdminExpiredBooksState extends State<AdminExpiredBooks> {
  final BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Expired Books'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // stream: bookService.fetchExpiredBooks(),
        stream: bookService.getBooksStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No expired books found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              String bookTitle = data['title'];
              String author = data['author_id'];
              String imageUrl = data['cover_url'];
              String docID = doc.id;

              return ListTile(
                leading: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text('$bookTitle by $author'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await bookService.deleteBook(docID);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
