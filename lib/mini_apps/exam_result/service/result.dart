import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:mimir/school/entity/school.dart';

import '../dao/result.dart';
import '../entity/result.dart';
import '../using.dart';

class ScoreService implements ExamResultDao {
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
  final ISession session;

  const ScoreService(this.session);

  /// 获取成绩
  @override
  Future<List<ExamResult>> getResultList(SchoolYear schoolYear, Semester semester) async {
    final response = await session.request(_scoreUrl, ReqMethod.post, para: {
      'gnmkdm': 'N305005',
      'doType': 'query',
    }, data: {
      // 学年名
      'xnm': schoolYear.toString(),
      // 学期名
      'xqm': semesterToFormField(semester),
      // 获取成绩最大数量
      'queryModel.showCount': 100,
    });
    return _parseScoreListPage(response.data);
  }

  /// 获取成绩详情
  @override
  Future<List<ExamResultDetail>> getResultDetail(String classId, SchoolYear schoolYear, Semester semester) async {
    var response = await session.request(
      _scoreDetailUrl,
      ReqMethod.post,
      para: {'gnmkdm': 'N305005'},
      data: {
        // 班级
        'jxb_id': classId,
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester)
      },
    );
    return _parseDetailPage(response.data);
  }

  static List<ExamResult> _parseScoreListPage(Map<String, dynamic> jsonPage) {
    final List? scoreList = jsonPage['items'];
    if (scoreList == null) {
      return const [];
    } else {
      return scoreList.map((e) => ExamResult.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  static ExamResultDetail _mapToDetailItem(Bs4Element item) {
    f1(s) => s.replaceAll('&nbsp;', '').replaceAll(' ', '');
    f2(s) => s.replaceAll('【', '').replaceAll('】', '');
    f(s) => f1(f2(s));

    String type = item.find(_scoreFormSelector)!.innerHtml.trim();
    String percentage = item.find(_scorePercentageSelector)!.innerHtml.trim();
    String value = item.find(_scoreValueSelector)!.innerHtml;

    return ExamResultDetail(f(type), f(percentage), double.tryParse(f(value)) ?? double.nan);
  }

  static List<ExamResultDetail> _parseDetailPage(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final elements = soup.findAll(_scoreDetailPageSelector);

    return elements.map(_mapToDetailItem).toList();
  }
}
