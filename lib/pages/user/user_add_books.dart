import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/services/book_service.dart';
import 'package:ppb_fp/services/user_book_service.dart';

class Book {
  final String id;
  final String title;
  final String? author;
  final String? imageUrl;

  Book({required this.id, required this.title, this.author, this.imageUrl});

  factory Book.fromSnapshot(DocumentSnapshot snapshot) {
    return Book(
      id: snapshot.id,
      title: snapshot['title'] as String,
      author: snapshot['author_id'] as String?,
      imageUrl: snapshot['cover_url'] as String?,
    );
  }
}

class BookListState extends ChangeNotifier {
  late Stream<QuerySnapshot<Object?>> _allBooks;
  late Stream<QuerySnapshot<Object?>> _searchResults;

  BookListState() {
    _allBooks = BookService().getBooksStream();
    _searchResults = _allBooks;
  }

  Stream<QuerySnapshot<Object?>> get searchResults => _searchResults;
  Stream<QuerySnapshot<Object?>> get allBooks => _allBooks;

  set setSearchResults(Stream<QuerySnapshot<Object?>> value) {
    _searchResults = value;
    notifyListeners();
  }

  final BorrowedBooksService borrowBooksService = BorrowedBooksService();
  final BookService bookService = BookService();
}

class AddBookPage extends StatefulWidget {
  final String userUid;

  const AddBookPage({Key? key, required this.userUid}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final bookListState = BookListState();
  final BorrowedBooksService borrowBooksService = BorrowedBooksService();
  final BookService bookService = BookService();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    bookListState.setSearchResults = bookService.getBooksStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Books',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() {
                    bookListState.setSearchResults =
                        bookService.getBookByTitle(_searchText);
                  }),
                ),
              ),
              onChanged: (text) => setState(() => _searchText = text),
            ),
          ),
          Expanded(
            child: _buildBookList(bookListState.searchResults),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(Stream<QuerySnapshot<Object?>> booksStream) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: booksStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final books =
            snapshot.data!.docs.map((doc) => Book.fromSnapshot(doc)).toList();
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return ListTile(
              title: Text(book.title),
              subtitle: book.author != null ? Text(book.author!) : null,
              leading:
                  book.imageUrl != null ? Image.network(book.imageUrl!) : null,
              trailing: ElevatedButton(
                onPressed: () => _handleBorrowBook(book.id),
                child: const Text('Borrow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleBorrowBook(String bookUid) async {
    try {
      await bookListState.borrowBooksService.addBook(widget.userUid, bookUid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book borrowed successfully!'),
        ),
      );
      // Consider updating UI to reflect borrowed book (e.g., disable button)
    } catch (error) {
      String errorMessage = error.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }
}
