import '../entity/book.dart';
import '../entity/borrow.dart';

class BookModel {
  final String bookId;
  final String isbn;
  final String title;
  final String author;
  final String callNumber;
  final String? publisher;
  final String? publishDate;

  const BookModel({
    required this.bookId,
    required this.isbn,
    required this.title,
    required this.author,
    required this.callNumber,
    this.publisher,
    this.publishDate,
  });

  @override
  String toString() {
    return {
      "bookId": bookId,
      "isbn": isbn,
      "title": title,
      "author": author,
      "publisher": publisher,
      "publishDate": publishDate,
      "callNumber": callNumber,
    }.toString();
  }

  factory BookModel.fromBook(Book book) {
    return BookModel(
      bookId: book.bookId,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      callNumber: book.callNumber,
      publisher: book.publisher,
      publishDate: book.publishDate,
    );
  }

  factory BookModel.fromBorrowed(BorrowedBookItem book) {
    return BookModel(
      bookId: book.bookId,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      callNumber: book.callNumber,
    );
  }

  factory BookModel.fromBorrowHistory(BookBorrowingHistoryItem book) {
    return BookModel(
      bookId: book.bookId,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      callNumber: book.callNumber,
    );
  }
}
