import 'package:sit/utils/hive.dart';
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

  LibraryBorrowStorage();

  List<BorrowedBookItem>? getBorrowedBooks() => box.safeGet<List>(_K.borrowed)?.cast<BorrowedBookItem>();

  Future<void> setBorrowedBooks(List<BorrowedBookItem>? value) => box.safePut<List>(_K.borrowed, value);

  late final $borrowed = box.provider<List<BorrowedBookItem>>(_K.borrowed, get: getBorrowedBooks);

  List<BookBorrowingHistoryItem>? getBorrowHistory() =>
      box.safeGet<List>(_K.borrowHistory)?.cast<BookBorrowingHistoryItem>();

  Future<void> setBorrowHistory(List<BookBorrowingHistoryItem>? value) => box.safePut<List>(_K.borrowHistory, value);
}
