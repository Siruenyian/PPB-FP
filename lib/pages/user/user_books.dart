import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/services/user_book_service.dart';

class BorrowedBooksPage extends StatefulWidget {
  final String userUid;

  const BorrowedBooksPage({Key? key, required this.userUid}) : super(key: key);

  @override
  _BorrowedBooksPageState createState() => _BorrowedBooksPageState();
}

class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
  final BorrowedBooksService borrowedBooksService = BorrowedBooksService();
  late Future<List<DocumentSnapshot>> _borrowedBooksFuture;

  @override
  void initState() {
    super.initState();
    _fetchBorrowedBooks();
  }

  void _fetchBorrowedBooks() {
    setState(() {
      _borrowedBooksFuture = borrowedBooksService.getBooksByUserID(widget.userUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _borrowedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No borrowed books found'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final bookId = book.id;
                final title = book['title'] ?? 'No title';
                final authorUid = book['author_id'] ?? 'No author';
                final coverUrl = book['cover_url'] ?? '';

                return ListTile(
                  leading: coverUrl.isNotEmpty
                      ? Image.network(coverUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(title),
                  subtitle: Text(authorUid),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await borrowedBooksService.removeBook(widget.userUid, bookId);
                      _fetchBorrowedBooks(); // Refresh the list after deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book removed successfully')),
                      );
                    },
                  ),
                  onTap: () {
                    // Handle book tap
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
