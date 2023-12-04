import 'package:sit/storage/hive/type_id.dart';

part "book.g.dart";

@HiveType(typeId: CacheHiveType.libraryBook)
class Book {
  @HiveField(0)
  final String bookId;
  @HiveField(1)
  final String isbn;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String author;
  @HiveField(4)
  final String publisher;
  @HiveField(5)
  final String publishDate;
  @HiveField(6)
  final String callNumber;

  const Book({
    required this.bookId,
    required this.isbn,
    required this.title,
    required this.author,
    required this.publisher,
    required this.publishDate,
    required this.callNumber,
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
}

@HiveType(typeId: CacheHiveType.libraryBookDetails)
class BookDetails {
  @HiveField(0)
  final Map<String, String> details;

  const BookDetails({
    required this.details,
  });

  @override
  String toString() {
    return details.toString();
  }
}

class BookSearchResult {
  final int resultCount;
  final double useTime;
  final int currentPage;
  final int totalPages;
  final List<Book> books;

  const BookSearchResult({
    required this.resultCount,
    required this.useTime,
    required this.currentPage,
    required this.totalPages,
    required this.books,
  });

  const BookSearchResult.empty({
    this.resultCount = 0,
    required this.useTime,
    this.currentPage = 0,
    this.totalPages = 0,
    this.books = const [],
  });

  @override
  String toString() {
    return {
      "resultCount": resultCount,
      "useTime": useTime,
      "currentPage": currentPage,
      "totalPages": totalPages,
      "books": books,
    }.toString();
  }
}
