class Book {
  final String bookId;
  final String isbn;
  final String title;
  final String author;
  final String publisher;
  final String publishDate;
  final String callNo;

  const Book({
    required this.bookId,
    required this.isbn,
    required this.title,
    required this.author,
    required this.publisher,
    required this.publishDate,
    required this.callNo,
  });

  @override
  String toString() {
    return 'Book{bookId: $bookId, isbn: $isbn, title: $title, author: $author, publisher: $publisher, publishDate: $publishDate, callNo: $callNo}';
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
    return 'BookSearchResult{resultCount: $resultCount, useTime: $useTime, currentPage: $currentPage, totalPages: $totalPages, books: $books}';
  }
}

class BookDetails {
  final Map<String, String> details;

  const BookDetails({
    required this.details,
  });
}
