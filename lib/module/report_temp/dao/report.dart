import '../entity/record.dart';

abstract class ReportDao {
  // 获取所有历史
  Future<List<ReportHistory>> getHistoryList(String userId);

  // 获取最新一次历史
  Future<ReportHistory?> getRecentHistory(String userId);
}
