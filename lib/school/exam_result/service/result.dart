import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/session/sis.dart';

import '../entity/result.dart';

class ExamResultService {
  static const _scoreUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html';
  static const _scoreDetailUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxCjxqGjh.html';

  /* Why there child is 1,3,5 not 1,2,3?
    The example likes follow:
          <tr>
              <td valign="middle">【 平时 】</td>
              <td valign="middle">40%&nbsp;</td>
              <td valign="middle">77.5&nbsp;</td>
          </tr>
    When you use 1,2,3 to choose the <td>, you will get [] by 2,
    it's because /n is chosen by 2 in dart,so here use 1,3,5 to choose <td>
  */
  static const _scoreDetailPageSelector = 'div.table-responsive > #subtab > tbody > tr';
  static const _scoreFormSelector = 'td:nth-child(1)';
  static const _scorePercentageSelector = 'td:nth-child(3)';
  static const _scoreValueSelector = 'td:nth-child(5)';
  final SisSession session;

  const ExamResultService(this.session);

  /// 获取成绩
  Future<List<ExamResult>> getResultList(SemesterInfo info) async {
    final response = await session.request(_scoreUrl, ReqMethod.post, para: {
      'gnmkdm': 'N305005',
      'doType': 'query',
    }, data: {
      // 学年名
      'xnm': info.year.toString(),
      // 学期名
      'xqm': semesterToFormField(info.semester),
      // 获取成绩最大数量
      'queryModel.showCount': 100,
    });
    final resultList = _parseScoreListPage(response.data);
    final newResultList = <ExamResult>[];
    for (final result in resultList) {
      final resultItems =
          await getResultItems((year: result.year, semester: result.semester), classId: result.innerClassId);
      newResultList.add(result.copyWith(items: resultItems));
    }
    return newResultList;
  }

  /// 获取成绩详情
  Future<List<ExamResultItem>> getResultItems(
    SemesterInfo info, {
    required String classId,
  }) async {
    final response = await session.request(
      _scoreDetailUrl,
      ReqMethod.post,
      para: {'gnmkdm': 'N305005'},
      data: {
        // 班级
        'jxb_id': classId,
        // 学年名
        'xnm': info.year.toString(),
        // 学期名
        'xqm': semesterToFormField(info.semester)
      },
    );
    final html = response.data as String;
    return _parseDetailPage(html);
  }

  static List<ExamResult> _parseScoreListPage(Map<String, dynamic> jsonPage) {
    final List? scoreList = jsonPage['items'];
    if (scoreList == null) return const [];
    return scoreList.map((e) => ExamResult.fromJson(e as Map<String, dynamic>)).toList();
  }

  static ExamResultItem _mapToDetailItem(Bs4Element item) {
    f1(s) => s.replaceAll('&nbsp;', '').replaceAll(' ', '');
    f2(s) => s.replaceAll('【', '').replaceAll('】', '');
    f(s) => f1(f2(s));

    String type = item.find(_scoreFormSelector)!.innerHtml.trim();
    String percentage = item.find(_scorePercentageSelector)!.innerHtml.trim();
    String value = item.find(_scoreValueSelector)!.innerHtml;

    return ExamResultItem(f(type), f(percentage), double.tryParse(f(value)) ?? double.nan);
  }

  static List<ExamResultItem> _parseDetailPage(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final elements = soup.findAll(_scoreDetailPageSelector);

    return elements.map(_mapToDetailItem).toList();
  }
}
