import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ppb_fp/services/book_service.dart';

class ViewBookPage extends StatefulWidget {
  final String bookUid;

  const ViewBookPage({Key? key, required this.bookUid}) : super(key: key);

  @override
  _ViewBookPageState createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  final BookService bookService =
      BookService(); // Assuming you have a BookService instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: bookService.getBookByID(widget.bookUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            String title = data['title'] ?? 'Unknown';
            String coverUrl = data['cover_url'] ?? '';
            String authorUid = data['author_id'] ?? 'Unknown';
            String citation = data['citation'] ?? '';
            String description = data['description'] ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (coverUrl.isNotEmpty)
                    Image.network(
                      coverUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    '$title',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Written By: $authorUid',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description: $description',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Citations: $citation',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: "$citation"));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Copy Citation',
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
