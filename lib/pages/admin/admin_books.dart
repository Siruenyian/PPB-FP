import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/user/comment_page.dart';
import 'package:ppb_fp/services/book_service.dart';

class AdminBooksPage extends StatefulWidget {
  const AdminBooksPage({super.key});

  @override
  State<AdminBooksPage> createState() => _AdminBooksPageState();
}

class _AdminBooksPageState extends State<AdminBooksPage> {
  final TextEditingController titletextController = TextEditingController();
  final TextEditingController coverurltextController = TextEditingController();
  final TextEditingController desctextController = TextEditingController();
  final TextEditingController authorsidController = TextEditingController();
  final TextEditingController citationController = TextEditingController();
  final BookService bookService = BookService();
  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void openBookBox(BuildContext context, {String? docID}) async {
    if (docID != null) {
      // Fetch the book data
      DocumentSnapshot doc = await bookService.getBookByID(docID);
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        titletextController.text = data['title'] ?? '';
        coverurltextController.text = data['cover_url'] ?? '';
        desctextController.text = data['description'] ?? '';
        authorsidController.text = data['author_id'] ?? '';
        citationController.text = data['citation'] ?? '';
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titletextController,
                cursorColor: Colors.blue,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: coverurltextController,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  labelText: 'Cover URL',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: desctextController,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: authorsidController,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  labelText: 'AuthorId',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: citationController,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  labelText: 'Citation',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (docID == null) {
                bookService.addBook(
                  titletextController.text,
                  coverurltextController.text,
                  authorsidController.text,
                  desctextController.text,
                  citationController.text,
                );
              } else {
                bookService.updateBook(
                  docID,
                  titletextController.text,
                  coverurltextController.text,
                  authorsidController.text,
                  desctextController.text,
                  citationController.text,
                );
              }
              titletextController.clear();
              coverurltextController.clear();
              desctextController.clear();
              authorsidController.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        tooltip: 'Press me to add Books!',
        onPressed: () {
          openBookBox(context, docID: null);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookService.getBooksStream(),
        builder: (context, snapshot) {
          // if data, get
          if (!snapshot.hasData) {
            return const Center(child: const CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No books found.'));
          }

          List BooksList = snapshot.data!.docs;
          return ListView.separated(
            itemCount: BooksList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, index) {
              // get each, get Book drom doc, display list
              DocumentSnapshot document = BooksList[index];
              String docID = document.id;
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String bookText = data['title'];
              String coverUrl = data['cover_url'] ?? '';
              return GestureDetector(
                  onTap: () {
                    // Navigate to the CommentsScreen when the tile is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsPage(bookId: docID),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        coverUrl.isNotEmpty
                            ? Image.network(
                                coverUrl,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 50,
                                width: 50,
                                color: Colors.grey,
                                child: const Center(
                                  child: Text('No Image Available',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                              '${bookText} by author ${data['author_id']}'),
                        ),
                      ],
                    ),
                    tileColor: Colors.grey[100],
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            openBookBox(context, docID: docID);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            bookService.deleteBook(docID);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
