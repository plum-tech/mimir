import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  Listenable listenBorrowedBooks() => box.listenable(keys: [_K.borrowed]);

  List<BookBorrowingHistoryItem>? getBorrowHistory() =>
      (box.get(_K.borrowHistory) as List<dynamic>?)?.cast<BookBorrowingHistoryItem>();

  Future<void> setBorrowHistory(List<BookBorrowingHistoryItem>? value) => box.put(_K.borrowHistory, value);
}
