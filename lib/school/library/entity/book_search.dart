import 'package:easy_localization/easy_localization.dart';

enum SearchMethod {
  any,
  title,
  primaryTitle,
  isbn,
  author,
  subject,
  $class,
  bookId,
  orderNumber,
  publisher,
  callNumber;

  String l10nName() => "library.searchMethod.$name".tr();
}

enum SortMethod {
  // 匹配度
  matchScore,
  // 出版日期
  publishDate,
  // 主题词
  subject,
  // 标题名
  title,
  // 作者
  author,
  // 索书号
  callNo,
  // 标题名拼音
  pinyin,
  // 借阅次数
  loanCount,
  // 续借次数
  renewCount,
  // 题名权重
  titleWeight,
  // 正题名权重
  titleProperWeight,
  // 卷册号
  volume;

  String l10nName() => "library.sortMethod.$name".tr();
}

enum SortOrder {
  asc,
  desc,
}

class Book {
  String bookId;
  String isbn;
  String title;
  String author;
  String publisher;
  String publishDate;
  String callNo;

  Book(this.bookId, this.isbn, this.title, this.author, this.publisher, this.publishDate, this.callNo);

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

  BookSearchResult(this.resultCount, this.useTime, this.currentPage, this.totalPages, this.books);

  @override
  String toString() {
    return 'BookSearchResult{resultCount: $resultCount, useTime: $useTime, currentPage: $currentPage, totalPages: $totalPages, books: $books}';
  }
}
