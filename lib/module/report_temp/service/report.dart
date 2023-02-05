import '../dao/report.dart';
import '../entity/record.dart';
import '../using.dart';

class ReportService implements ReportDao {
  final ISession session;

  const ReportService(this.session);

  static const String _historyUrl = 'http://xgfy.sit.edu.cn/report/report/getMyReport';

  @override
  Future<List<ReportHistory>> getHistoryList(String userId) async {
    final response = await session.request(
      _historyUrl,
      ReqMethod.post,
      data: {
        'usercode': userId,
        'batchno': '', // TODO：batchno 填入今天日期？yyyyMMdd
      },
      options: SessionOptions(
        contentType: HeaderConstants.jsonContentType,
        responseType: SessionResType.json,
      ),
    );

    final Map<String, dynamic> data = response.data;
    final responseCode = data['code'];
    if (responseCode == 0) {
      final List userHistory = data['data'];
      return userHistory.map((e) => ReportHistory.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('($responseCode) ${data['msg']}');
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
