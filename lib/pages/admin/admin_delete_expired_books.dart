import 'package:flutter/material.dart';
import 'package:ppb_fp/services/user_book_service.dart';

class AdminExpiredBooks extends StatefulWidget {
  const AdminExpiredBooks({Key? key}) : super(key: key);

  @override
  State<AdminExpiredBooks> createState() => _AdminExpiredBooksState();
}

class _AdminExpiredBooksState extends State<AdminExpiredBooks> {
  final BorrowedBooksService bookService = BorrowedBooksService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Expired Books'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  deleteAllExpiredBooks();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Delete All Expired Books',
                )),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: bookService.getTotalExpiredBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int totalExpiredBooks = snapshot.data ?? 0;
                  return Text(
                    'Total Expired Books: $totalExpiredBooks',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteAllExpiredBooks() async {
    try {
      await bookService.deleteAllExpiredBooks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All expired books deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting expired books: $e'),
        ),
      );
    }
  }
}
