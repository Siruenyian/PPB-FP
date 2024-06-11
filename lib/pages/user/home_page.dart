import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ppb_fp/pages/user/book_explore.dart';
import 'package:ppb_fp/pages/user/user_books.dart';
import 'package:ppb_fp/pages/user/user_add_books.dart';

import 'package:cloud_firestore/cloud_firestore.dart';



class UserHomePage extends StatelessWidget {
  UserHomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome User: ${user?.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BooksPage()),
                );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              ),
              child: const Text('Explore Books Exists'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BorrowedBooksPage(userUid: user!.uid)),
                );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              ),
              child: const Text('View Borrowed Books'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBookPage(userUid: user!.uid)),
                );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              ),
              child: const Text('Borrow Books'),
            ),
          ],
        ),
      ),
    );
  }
}
