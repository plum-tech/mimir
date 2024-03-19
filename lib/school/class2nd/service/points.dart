import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sit/init.dart';

import 'package:sit/school/utils.dart';
import 'package:sit/session/class2nd.dart';

import '../entity/activity.dart';
import '../entity/application.dart';
import '../entity/attended.dart';

class Class2ndPointsService {
  static const homeUrl = 'http://sc.sit.edu.cn/public/init/index.action';
  static const scoreUrl = 'http://sc.sit.edu.cn/public/pcenter/scoreDetail.action';
  static const myEventUrl = 'http://sc.sit.edu.cn/public/pcenter/activityOrderList.action?pageSize=999';

  Class2ndSession get _session => Init.class2ndSession;

  const Class2ndPointsService();

  /// 获取第二课堂分数
  Future<Class2ndPointsSummary> fetchScoreSummary() async {
    final response = await _session.request(
      homeUrl,
      options: Options(
        method: "POST",
      ),
    );
    final data = response.data;
    return _parseScoreSummary(data);
  }

  static Class2ndPointsSummary _parseScoreSummary(String htmlPage) {
    final html = BeautifulSoup(htmlPage);

    final (:thematicReport, :practice, :creation, :schoolCulture, :schoolSafetyCivilization, :voluntary) =
        _parseAllStatus(html);

    final honestyPoints = _parseHonestyPoints(html);
    final total = _parseTotalPoints(html);
    return Class2ndPointsSummary(
      thematicReport: thematicReport,
      practice: practice,
      creation: creation,
      schoolSafetyCivilization: schoolSafetyCivilization,
      voluntary: voluntary,
      schoolCulture: schoolCulture,
      honestyPoints: honestyPoints,
      totalPoints: total,
    );
  }

  static ({
    double thematicReport,
    double practice,
    double creation,
    double schoolSafetyCivilization,
    double voluntary,
    double schoolCulture,
  }) _parseAllStatus(BeautifulSoup html) {
    // 学分=1.5(主题报告)+2.0(社会实践)+1.5(创新创业创意)+1.0(校园安全文明)+0.0(公益志愿)+2.0(校园文化)
    final found = html.find('#span_score')!;
    final String scoreText = found.text;
    final regExp = RegExp(r'([\d.]+)\(([\u4e00-\u9fa5]+)\)');

    late final double lecture, practice, creation, safetyEdu, voluntary, campus;

    final matches = regExp.allMatches(scoreText);
    for (final item in matches) {
      final score = double.parse(item.group(1) ?? '0.0');
      final typeName = item.group(2)!;
      final type = Class2ndPointType.parse(typeName);

      switch (type) {
        case Class2ndPointType.thematicReport:
          lecture = score;
          break;
        case Class2ndPointType.creation:
          creation = score;
          break;
        case Class2ndPointType.schoolCulture:
          campus = score;
          break;
        case Class2ndPointType.practice:
          practice = score;
          break;
        case Class2ndPointType.voluntary:
          voluntary = score;
          break;
        case Class2ndPointType.schoolSafetyCivilization:
          safetyEdu = score;
          break;
        case null:
          break;
      }
    }
    return (
      thematicReport: lecture,
      practice: practice,
      creation: creation,
      schoolSafetyCivilization: safetyEdu,
      voluntary: voluntary,
      schoolCulture: campus,
    );
  }

  static final honestyPointsRe = RegExp(r'诚信积分：(\S+)');

  static double _parseHonestyPoints(BeautifulSoup html) {
    final element = html.find("div", attrs: {"onmouseover": "showSynopsis()"});
    var honestyPoints = 0.0;
    if (element != null) {
      final pointsRaw = honestyPointsRe.firstMatch(element.text)?.group(1);
      if (pointsRaw != null) {
        final points = double.tryParse(pointsRaw);
        if (points != null) {
          honestyPoints = points;
        }
      }
    }
    return honestyPoints;
  }

  static const totalPoints = '#content-box > div.user-info > div:nth-child(3) > font';

  static double _parseTotalPoints(BeautifulSoup html) {
    final pointsRaw = html.find(totalPoints);
    if (pointsRaw != null) {
      final total = double.tryParse(pointsRaw.text);
      if (total != null) {
        return total;
      }
    }
    return 0.0;
  }

  /// 获取我的得分列表
  Future<List<Class2ndPointItem>> fetchScoreItemList() async {
    final response = await _session.request(
      scoreUrl,
      options: Options(
        method: "POST",
      ),
    );
    return _parseScoreList(response.data);
  }

  static final scoreItemTimeFormat = DateFormat('yyyy-MM-dd hh:mm');

  static List<Class2ndPointItem> _parseScoreList(String htmlPage) {
    Class2ndPointItem nodeToScoreItem(Bs4Element item) {
      final title = item.find('td:nth-child(3)')!.text.trim();
      final timeRaw = item.find('td:nth-child(9) > a');
      final time = timeRaw == null ? null : scoreItemTimeFormat.parse(timeRaw.text.trim());
      final idRaw = item.find('td:nth-child(7)');
      final id = int.parse(idRaw!.innerHtml.trim());
      // 注意：“我的成绩” 页面中，成绩条目显示的是活动类型，而非加分类型, 因此使用 ActivityType.
      final categoryRaw = item.find('td:nth-child(5)')!.innerHtml.trim();
      final category = Class2ndActivityCat.parse(categoryRaw);
      assert(category != null, "Unknown class2nd category $categoryRaw");
      final points = double.parse(item.find('td:nth-child(11) > span')!.innerHtml.trim());
      final honestyPointsRaw = item.find('td:nth-child(13) > span')!.innerHtml.trim();
      final honestyPoints = honestyPointsRaw.startsWith("+-")
          ? double.parse(honestyPointsRaw.substring(1))
          : double.parse(honestyPointsRaw);

      return Class2ndPointItem(
        name: mapChinesePunctuations(title),
        activityId: id,
        category: category ?? Class2ndActivityCat.unknown,
        time: time,
        points: points,
        honestyPoints: honestyPoints,
      );
    }

    return BeautifulSoup(htmlPage)
        .findAll('#div1 > div.table_style_4 > form > table:nth-child(7) > tbody > tr')
        .map(nodeToScoreItem)
        .toList();
  }

  /// 获取我的活动列表
  Future<List<Class2ndActivityApplication>> fetchActivityApplicationList() async {
    final response = await _session.request(
      myEventUrl,
      options: Options(
        method: "POST",
      ),
    );
    return _parseActivityApplicationList(response.data);
  }

  static List<Class2ndActivityApplication> _parseActivityApplicationList(String htmlPage) {
    final html = BeautifulSoup(htmlPage);
    return html
        .findAll('#content-box > div:nth-child(23) > div.table_style_4 > form > table > tbody > tr')
        .map((e) => _activityMapDetail(e))
        .where(filterDeletedActivity)
        .toList();
  }

  static bool filterDeletedActivity(Class2ndActivityApplication x) => x.activityId != 0;

  static final attendedTimeFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  static final activityIdRe = RegExp(r'activityId=(\d+)');

  static Class2ndActivityApplication _activityMapDetail(Bs4Element item) {
    final applyIdText = item.find('td:nth-child(1)')!.text.trim();
    final applicationId = int.parse(applyIdText);
    final activityIdText = item.find('td:nth-child(3)')!.innerHtml.trim();
    // 部分取消了的活动，活动链接不存在，这里将活动 id 记为 -1.
    final activityId = int.parse(activityIdRe.firstMatch(activityIdText)?.group(1) ?? '-1');
    final title = item.find('td:nth-child(3)')!.text.trim();
    final categoryRaw = item.find('td:nth-child(5)')!.text.trim();
    final category = Class2ndActivityCat.parse(categoryRaw);
    assert(category != null, "Unknown class2nd category $categoryRaw");
    final timeRaw = item.find('td:nth-child(7)')!.text.trim();
    final time = attendedTimeFormat.parse(timeRaw);
    final status = item.find('td:nth-child(9)')!.text.trim();

    return Class2ndActivityApplication(
      applicationId: applicationId,
      activityId: activityId,
      title: mapChinesePunctuations(title),
      category: category ?? Class2ndActivityCat.unknown,
      time: time,
      status: status,
    );
  }
}
