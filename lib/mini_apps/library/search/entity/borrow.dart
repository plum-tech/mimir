/// 借书记录
class BorrowBookItem {
  /// 图书号
  String bookId = '';

  /// 条码号
  String barcode = '';

  String isbn = '';

  String author = '';

  /// 题名
  String title = '';

  /// 索书号
  String callNo = '';

  /// 馆藏地点
  String location = '';

  /// 图书类型
  String type = '';

  /// 借出日期
  DateTime borrowDate = DateTime.now();

  /// 应还日期
  DateTime expireDate = DateTime.now();

  @override
  String toString() {
    return 'BorrowBookItem{bookId: $bookId, barcode: $barcode, isbn: $isbn, author: $author, title: $title, callNo: $callNo, location: $location, type: $type, borrowDate: $borrowDate, expireDate: $expireDate}';
  }
}

/// 历史借书记录
class HistoryBorrowBookItem {
  /// 图书号
  String bookId = '';

  /// 操作类型
  String operateType = '';

  /// 条码号
  String barcode = '';

  /// 题名
  String title = '';

  String isbn = '';

  /// 索书号
  String callNo = '';

  /// 馆藏地点
  String location = '';

  /// 图书类型
  String type = '';

  /// 著者
  String author = '';

  /// 处理日期
  DateTime processDate = DateTime.now();

  @override
  String toString() {
    return 'HistoryBorrowBookItem{bookId: $bookId, operateType: $operateType, barcode: $barcode, title: $title, isbn: $isbn, callNo: $callNo, location: $location, type: $type, author: $author, processDate: $processDate}';
  }
}
