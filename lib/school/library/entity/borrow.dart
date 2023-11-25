/// 借书记录
class BorrowBookItem {
  /// 图书号
  final String bookId;

  /// 条码号
  final String barcode;

  final String isbn;

  final String author;

  /// 题名
  final String title;

  /// 索书号
  final String callNo;

  /// 馆藏地点
  final String location;

  /// 图书类型
  final String type;

  /// 借出日期
  final DateTime borrowDate;

  /// 应还日期
  final DateTime expireDate;

  const BorrowBookItem({
    required this.bookId,
    required this.barcode,
    required this.isbn,
    required this.author,
    required this.title,
    required this.callNo,
    required this.location,
    required this.type,
    required this.borrowDate,
    required this.expireDate,
  });

  @override
  String toString() {
    return 'BorrowBookItem{bookId: $bookId, barcode: $barcode, isbn: $isbn, author: $author, title: $title, callNo: $callNo, location: $location, type: $type, borrowDate: $borrowDate, expireDate: $expireDate}';
  }
}

/// 历史借书记录
class BorrowBookHistoryItem {
  /// 图书号
  final String bookId;

  /// 操作类型
  final String operateType;

  /// 条码号
  final String barcode;

  /// 题名
  final String title;

  final String isbn;

  /// 索书号
  final String callNo;

  /// 馆藏地点
  final String location;

  /// 图书类型
  final String type;

  /// 著者
  final String author;

  /// 处理日期
  final DateTime processDate;

  const BorrowBookHistoryItem({
    required this.bookId,
    required this.operateType,
    required this.barcode,
    required this.title,
    required this.isbn,
    required this.callNo,
    required this.location,
    required this.type,
    required this.author,
    required this.processDate,
  });

  @override
  String toString() {
    return 'HistoryBorrowBookItem{bookId: $bookId, operateType: $operateType, barcode: $barcode, title: $title, isbn: $isbn, callNo: $callNo, location: $location, type: $type, author: $author, processDate: $processDate}';
  }
}
