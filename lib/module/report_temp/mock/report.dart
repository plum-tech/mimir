import '../dao/report.dart';
import '../entity/record.dart';

class ReportServiceMock implements ReportDao {
  @override
  Future<List<ReportHistory>> getHistoryList(String userId) async {
    return const [
      ReportHistory(20220929, '测试地点', 1),
    ];
  }

  // 获取最新一次历史
  @override
  Future<ReportHistory?> getRecentHistory(String userId) async {
    final historyList = await getHistoryList(userId);
    ReportHistory? result;
    try {
      // 元素不存在时，first getter 会抛出异常.
      result = historyList.first;
    } catch (_) {}
    return result;
  }
}
