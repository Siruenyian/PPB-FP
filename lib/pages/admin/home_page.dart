import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ppb_fp/services/firestore_book.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final TextEditingController titletextController = TextEditingController();
  final TextEditingController coverurltextController = TextEditingController();
  final TextEditingController desctextController = TextEditingController();
  final TextEditingController authorsidController = TextEditingController();
  final FireStoreService firestoreService = FireStoreService();
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
              DropdownButton<String>(
                value: selectedAuthorId.isEmpty ? null : selectedAuthorId,
                hint: const Text('Select Author'),
                items: authorItems,
                onChanged: (String? newValue) {
                  selectedAuthorId = newValue!;
                },
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
                firestoreService.addBook(
                  titletextController.text,
                  coverurltextController.text,
                  desctextController.text,
                  selectedAuthorId,
                );
              } else {
                firestoreService.updateBook(
                  docID,
                  titletextController.text,
                  coverurltextController.text,
                  desctextController.text,
                  selectedAuthorId,
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
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Admin: ${user?.email}',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout),
            ),
          ]),
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
        stream: firestoreService.getBooksStream(),
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
                return ListTile(
                  title: Text('${bookText} by author ${data['author_id']}'),
                  tileColor: Colors.grey[200],
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            openBookBox(context, docID: docID);
                          },
                          icon: const Icon(Icons.settings)),
                      IconButton(
                          onPressed: () {
                            firestoreService.deleteBook(docID);
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
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
