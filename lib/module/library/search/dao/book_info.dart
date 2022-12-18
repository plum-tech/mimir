import '../entity/book_info.dart';

abstract class BookInfoDao {
  /// 根据图书id查询图书详情信息
  Future<BookInfo> query(String bookId);
}
