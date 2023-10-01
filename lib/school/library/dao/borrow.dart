import '../entity/borrow.dart';

abstract class LibraryBorrowDao {
  /// 获取用户的借阅记录
  Future<List<BorrowBookItem>> getMyBorrowBookList(int page, int rows);

  /// 续借图书
  Future<String> renewBook({
    required List<String> barcodeList,
    bool renewAll = false,
  });

  /// 用户的历史借阅情况
  Future<List<HistoryBorrowBookItem>> getHistoryBorrowBookList(int page, int rows);
}
