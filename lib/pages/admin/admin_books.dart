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
  final BookService bookService = BookService();
  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void openBookBox(BuildContext context, {String? docID}) {
    String selectedAuthorId = '';
    List<DropdownMenuItem<String>> authorItems = [
      const DropdownMenuItem<String>(
        value: '1',
        child: Text('Sault Goodman'),
      ),
      const DropdownMenuItem<String>(
        value: '2',
        child: Text('Walter White'),
      ),
      const DropdownMenuItem<String>(
        value: '3',
        child: Text('Steven'),
      ),
    ];
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
                );
              } else {
                bookService.updateBook(
                  docID,
                  titletextController.text,
                  coverurltextController.text,
                  authorsidController.text,
                  desctextController.text,
                );
              }
              titletextController.clear();
              coverurltextController.clear();
              desctextController.clear();
              authorsidController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
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
          openBookBox(context);
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
          if (snapshot.hasData) {
            List BooksList = snapshot.data!.docs;
            return ListView.separated(
              itemCount: BooksList.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (context, index) {
                // get each, get Book drom doc, display list
                DocumentSnapshot document = BooksList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String bookText = data['title'];
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
                          Image.network(
                            data[
                                'cover_url'], // Assuming you have the image URL in your data
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                '${bookText} by author ${data['author_id']}'),
                          ),
                        ],
                      ),
                      tileColor: Colors.grey[200],
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
          } else {
            return const Text('No Books here...');
          }
        },
      ),
    );
  }
}
