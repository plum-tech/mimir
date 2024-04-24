import 'package:hive/hive.dart';
import 'package:sit/utils/hive.dart';
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

  Book? getBook(String bookId) => box.safeGet<Book>(_K.info(bookId));

  Future<void> setBook(String bookId, Book? value) => box.safePut<Book>(_K.info(bookId), value);

  BookDetails? getBookDetails(String bookId) => box.safeGet<BookDetails>(_K.details(bookId));

  Future<void> setBookDetails(String bookId, BookDetails? value) => box.safePut<BookDetails>(_K.details(bookId), value);
}
