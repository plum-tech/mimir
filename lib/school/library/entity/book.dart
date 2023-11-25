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

  @override
  String toString() {
    return 'BookSearchResult{resultCount: $resultCount, useTime: $useTime, currentPage: $currentPage, totalPages: $totalPages, books: $books}';
  }
}

class BookInfo {
  final String title;
  final String isbn;
  final String price;
  final Map<String, String> rawDetail;

  const BookInfo({
    required this.title,
    required this.isbn,
    required this.price,
    required this.rawDetail,
  });
}
