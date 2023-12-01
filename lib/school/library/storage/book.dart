import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/book.dart';

class _K {
  static const ns = "/library/books";

  static String info(String bookId) => "$ns/$bookId";

  static String details(String bookId) => "$ns/$bookId";
}

class LibraryBookStorage {
  Box get box => HiveInit.library;

  const LibraryBookStorage();

  Book? getBook(String bookId) => box.get(_K.info(bookId));

  Future<void> setBook(String bookId, Book? book) => box.put(_K.info(bookId), book);

  BookDetails? getBookDetails(String bookId) => box.get(_K.details(bookId));

  Future<void> setBookDetails(String bookId, BookDetails? book) => box.put(_K.details(bookId), book);
}
