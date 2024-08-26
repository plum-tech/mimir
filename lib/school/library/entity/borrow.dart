import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/storage/hive/type_id.dart';

part "borrow.g.dart";

@HiveType(typeId: CacheHiveType.libraryBorrowedBook)
class BorrowedBookItem {
  @HiveField(0)
  final String bookId;

  @HiveField(1)
  final DateTime borrowDate;

  @HiveField(2)
  final DateTime expireDate;

  @HiveField(3)
  final String barcode;

  @HiveField(4)
  final String isbn;

  @HiveField(5)
  final String callNumber;

  @HiveField(6)
  final String title;

  @HiveField(7)
  final String location;

  @HiveField(8)
  final String author;
  @HiveField(9)
  final String type;

  const BorrowedBookItem({
    required this.bookId,
    required this.barcode,
    required this.isbn,
    required this.author,
    required this.title,
    required this.callNumber,
    required this.location,
    required this.type,
    required this.borrowDate,
    required this.expireDate,
  });

  @override
  String toString() {
    return {
      "bookId": bookId,
      "barcode": barcode,
      "isbn": isbn,
      "author": author,
      "title": title,
      "callNumber": callNumber,
      "location": location,
      "type": type,
      "borrowDate": borrowDate,
      "expireDate": expireDate,
    }.toString();
  }
}

@HiveType(typeId: CacheHiveType.libraryBorrowingHistoryOp)
enum BookBorrowingHistoryOperation {
  @HiveField(0)
  borrowing,
  @HiveField(1)
  returning;

  String l10n() => "library.history.operation.$name".tr();
}

@HiveType(typeId: CacheHiveType.libraryBorrowingHistory)
class BookBorrowingHistoryItem {
  @HiveField(0)
  final String bookId;

  @HiveField(1)
  final DateTime processDate;

  @HiveField(2)
  final BookBorrowingHistoryOperation operation;

  @HiveField(3)
  final String barcode;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String isbn;

  @HiveField(6)
  final String callNumber;

  @HiveField(7)
  final String author;

  @HiveField(8)
  final String location;

  @HiveField(9)
  final String type;

  const BookBorrowingHistoryItem({
    required this.bookId,
    required this.operation,
    required this.barcode,
    required this.title,
    required this.isbn,
    required this.callNumber,
    required this.location,
    required this.type,
    required this.author,
    required this.processDate,
  });

  @override
  String toString() {
    return {
      "bookId": bookId,
      "operateType": operation,
      "barcode": barcode,
      "title": title,
      "isbn": isbn,
      "callNo": callNumber,
      "location": location,
      "type": type,
      "author": author,
      "processDate": processDate,
    }.toString();
  }
}
