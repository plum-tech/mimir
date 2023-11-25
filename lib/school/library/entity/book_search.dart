class Book {
  String bookId;
  String isbn;
  String title;
  String author;
  String publisher;
  String publishDate;
  String callNo;

  Book({
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
  int resultCount;
  double useTime;
  int currentPage;
  int totalPages;
  List<Book> books;

  BookSearchResult({
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
