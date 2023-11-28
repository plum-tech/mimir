import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sit/init.dart';

import 'package:sit/school/entity/school.dart';
import 'package:sit/session/class2nd.dart';

import '../entity/list.dart';
import '../entity/attended.dart';

class Class2ndScoreService {
  static const homeUrl = 'http://sc.sit.edu.cn/public/init/index.action';
  static const scoreUrl = 'http://sc.sit.edu.cn/public/pcenter/scoreDetail.action';
  static const myEventUrl = 'http://sc.sit.edu.cn/public/pcenter/activityOrderList.action?pageSize=999';

  static const $totalScore = '#content-box > div.user-info > div:nth-child(3) > font';

  static final activityIdRe = RegExp(r'activityId=(\d+)');

  Class2ndSession get session => Init.class2ndSession;

  const Class2ndScoreService();

  /// 获取第二课堂分数
  Future<Class2ndScoreSummary> fetchScoreSummary() async {
    final response = await session.request(
      homeUrl,
      options: Options(
        method: "POST",
      ),
    );
    final data = response.data;
    return _parseScoreSummary(data);
  }

  static Class2ndScoreSummary _parseScoreSummary(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);

    // 学分=1.5(主题报告)+2.0(社会实践)+1.5(创新创业创意)+1.0(校园安全文明)+0.0(公益志愿)+2.0(校园文化)
    final found = soup.find('#span_score')!;
    final String scoreText = found.text.toString();
    final regExp = RegExp(r'([\d.]+)\(([\u4e00-\u9fa5]+)\)');

    final matches = regExp.allMatches(scoreText);
    late final double lecture, practice, creation, safetyEdu, voluntary, campus;

    for (final item in matches) {
      final score = double.parse(item.group(1) ?? '0.0');
      final typeName = item.group(2)!;
      final type = Class2ndScoreType.parse(typeName);

      switch (type) {
        case Class2ndScoreType.thematicReport:
          lecture = score;
          break;
        case Class2ndScoreType.creation:
          creation = score;
          break;
        case Class2ndScoreType.schoolCulture:
          campus = score;
          break;
        case Class2ndScoreType.practice:
          practice = score;
          break;
        case Class2ndScoreType.voluntary:
          voluntary = score;
          break;
        case Class2ndScoreType.schoolSafetyCivilization:
          safetyEdu = score;
          break;
        case null:
          break;
      }
    }
    return Class2ndScoreSummary(
      thematicReport: lecture,
      practice: practice,
      creation: creation,
      schoolSafetyCivilization: safetyEdu,
      voluntary: voluntary,
      schoolCulture: campus,
    );
  }

  /// 获取我的得分列表
  Future<List<Class2ndScoreItem>> fetchScoreItemList() async {
    final response = await session.request(
      scoreUrl,
      options: Options(
        method: "POST",
      ),
    );
    return _parseScoreList(response.data);
  }

  static final scoreItemTimeFormat = DateFormat('yyyy-MM-dd hh:mm');

  static List<Class2ndScoreItem> _parseScoreList(String htmlPage) {
    Class2ndScoreItem nodeToScoreItem(Bs4Element item) {
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

      return Class2ndScoreItem(
        name: mapChinesePunctuations(title),
        activityId: id,
        category: category!,
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
    final response = await session.request(
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
      category: category!,
      time: time,
      status: status,
    );
  }
}
