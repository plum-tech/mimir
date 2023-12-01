import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/borrow.dart';

class _K {
  static const ns = "/library/borrow";
  static const borrowed = "$ns/borrowed";
  static const borrowHistory = "$ns/borrowHistory";
}

class LibraryBorrowStorage {
  Box get box => HiveInit.library;

  const LibraryBorrowStorage();

  List<BorrowedBookItem>? getBorrowedBooks() => (box.get(_K.borrowed) as List<dynamic>?)?.cast<BorrowedBookItem>();

  Future<void> setBorrowedBooks(List<BorrowedBookItem>? value) => box.put(_K.borrowed, value);

  List<BookBorrowHistoryItem>? getBorrowHistory() =>
      (box.get(_K.borrowHistory) as List<dynamic>?)?.cast<BookBorrowHistoryItem>();

  Future<void> setBorrowHistory( List<BookBorrowHistoryItem>? value) => box.put(_K.borrowHistory, value);
}
