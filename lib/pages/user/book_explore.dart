import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/services/book_service.dart';

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Books'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookService.getBooksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No books found'));
          } else {
            final books = snapshot.data!.docs;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final title = book['title'] ?? 'No title';
                final coverUrl = book['cover_url'] ?? '';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        coverUrl.isNotEmpty
                          ? Image.network(
                              coverUrl,
                              height: 300,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 300,
                              color: Colors.grey,
                              child: Center(
                                child: Text('No Image Available', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle book details navigation
                                },
                                child: Text('View Book'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}