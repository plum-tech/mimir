import '../entity/holding.dart';

abstract class HoldingInfoDao {
  Future<HoldingInfo> queryByBookId(String bookId);

  Future<List<String>> searchNearBookIdList(String bookId);
}
