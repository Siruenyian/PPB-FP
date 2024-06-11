import 'package:firebase_auth/firebase_auth.dart';
import 'package:ppb_fp/services/book_service.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/admin/admin_books.dart';
import 'package:ppb_fp/pages/admin/admin_delete_expired_books.dart';

import 'package:ppb_fp/pages/user/comment_page.dart';

class AdminHomePage extends StatefulWidget {
  AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final TextEditingController titletextController = TextEditingController();
  final TextEditingController coverurltextController = TextEditingController();
  final TextEditingController desctextController = TextEditingController();
  final TextEditingController authorsidController = TextEditingController();
  final BookService firestoreService = BookService();
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
          'Admin: ${user?.email}',
          style: TextStyle(fontSize: 18, color: Colors.white),
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
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        scrollDirection: Axis.horizontal,
        children: [
          AdminBooksPage(),
          AdminExpiredBooks(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.book,
                color: Colors.white,
              ),
              label: "Books List"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: "Delete Expired")
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            pageController.animateToPage(value,
                duration: Durations.medium1, curve: Curves.bounceIn);
            // currentIndex = value;
          });
        },
      ),
    );
  }
}
// Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Logged In as User: ${user?.email}',
//                 style: const TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AdminBooksPage()),
//                   );
//                 },
//                 child: const Text('Explore Books Exists'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => CommentsPage(
//                               bookId: '1gkCtEwsdgaFVxf7uidm',
//                             )),
//                   );
//                 },
//                 child: const Text('Explore Books Comments'),
//               ),
//             ],
//           ),