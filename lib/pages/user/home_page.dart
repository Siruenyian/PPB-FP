import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ppb_fp/pages/user/book_explore.dart';
import 'package:ppb_fp/pages/user/user_books.dart';
import 'package:ppb_fp/pages/user/user_add_books.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserHomePage extends StatefulWidget {
  UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final user = FirebaseAuth.instance.currentUser;

  int currentIndex = 0;

  PageController pageController = PageController(initialPage: 0);

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'User: ${user?.email}',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        pageSnapping: true,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        scrollDirection: Axis.horizontal,
        children: [
          BooksPage(),
          AddBookPage(userUid: user!.uid),
          BorrowedBooksPage(userUid: user!.uid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.book,
                color: Colors.white,
              ),
              label: "Explore Books"),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.bookmark_add,
                color: Colors.white,
              ),
              label: "Book Library"),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.bookmark_added_sharp,
                color: Colors.white,
              ),
              label: "Borrowed Books"),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            pageController.animateToPage(value,
                duration: Durations.medium1, curve: Curves.bounceInOut);
            // currentIndex = value;
          });
        },
      ),
    );
  }
}
