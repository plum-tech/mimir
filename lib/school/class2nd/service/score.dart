import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/class2nd.dart';

import '../entity/list.dart';
import '../entity/score.dart';

class Class2ndScoreService {
  static const homeUrl = 'http://sc.sit.edu.cn/public/init/index.action';
  static const scoreUrl = 'http://sc.sit.edu.cn/public/pcenter/scoreDetail.action';
  static const myEventUrl = 'http://sc.sit.edu.cn/public/pcenter/activityOrderList.action?pageSize=999';

  static const $totalScore = '#content-box > div.user-info > div:nth-child(3) > font';

  static final activityIdRe = RegExp(r'activityId=(\d+)');

  final Class2ndSession session;

  const Class2ndScoreService(this.session);

  static bool _initializedCookie = false;

  Future<void> _refreshCookie() async {
    if (!_initializedCookie) {
      await session.request('http://sc.sit.edu.cn/', ReqMethod.get);
      _initializedCookie = true;
    }
  }

  /// 获取第二课堂分数
  Future<Class2ndScoreSummary> fetchScoreSummary() async {
    await _refreshCookie();
    final response = await session.request(homeUrl, ReqMethod.post);
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
      final type = ActivityScoreType.parse(typeName);

      switch (type) {
        case ActivityScoreType.thematicReport:
          lecture = score;
          break;
        case ActivityScoreType.creation:
          creation = score;
          break;
        case ActivityScoreType.schoolCulture:
          campus = score;
          break;
        case ActivityScoreType.practice:
          practice = score;
          break;
        case ActivityScoreType.voluntary:
          voluntary = score;
          break;
        case ActivityScoreType.schoolSafetyCivilization:
          safetyEdu = score;
          break;
        case null:
          break;
      }
    }
    return Class2ndScoreSummary(
      lecture: lecture,
      practice: practice,
      creation: creation,
      safetyEdu: safetyEdu,
      voluntary: voluntary,
      campusCulture: campus,
    );
  }

  /// 获取我的得分列表
  Future<List<Class2ndScoreItem>> fetchScoreItemList() async {
    await _refreshCookie();
    final response = await session.request(scoreUrl, ReqMethod.post);
    return _parseScoreList(response.data);
  }

  static final scoreItemTimeFormat = DateFormat('yyyy-MM-dd hh:mm');

  static List<Class2ndScoreItem> _parseScoreList(String htmlPage) {
    if (htmlPage.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>')) {
      debugPrint("My score list needs refresh.");
      throw Exception("My score list needs refresh.");
    }
    Class2ndScoreItem nodeToScoreItem(Bs4Element item) {
      final title = item.find('td:nth-child(3)')!.text.trim();
      final timeRaw = item.find('td:nth-child(9) > a')!.text.trim();
      final time = scoreItemTimeFormat.parse(timeRaw);
      final idRaw = item.find('td:nth-child(7)');
      final id = int.parse(idRaw!.innerHtml.trim());
      // 注意：“我的成绩” 页面中，成绩条目显示的是活动类型，而非加分类型, 因此使用 ActivityType.
      final categoryName = item.find('td:nth-child(5)')!.innerHtml.trim();
      final category = Class2ndActivityCat.parse(categoryName);
      assert(category != null, "Unknown class2nd category $categoryName");
      final points = double.parse(item.find('td:nth-child(11) > span')!.innerHtml.trim());
      final honestyPoints = double.parse(item.find('td:nth-child(13) > span')!.innerHtml.trim());

      return Class2ndScoreItem(
        name: title,
        activityId: id,
        type: category!,
        time: time,
        points: points,
        honestyPoints: honestyPoints,
      );
    }

    // 得分列表里面，有一些条目加诚信分，此时常规得分为 0, 要把这些条目过滤掉。
    bool filterZeroScore(Class2ndScoreItem item) => item.points > 0.01;

    return BeautifulSoup(htmlPage)
        .findAll('#div1 > div.table_style_4 > form > table:nth-child(7) > tbody > tr')
        .map(nodeToScoreItem)
        .where(filterZeroScore)
        .toList();
  }

  /// 获取我的活动列表
  Future<List<Class2ndActivityApplication>> fetchActivityApplicationList() async {
    await _refreshCookie();
    final response = await session.request(myEventUrl, ReqMethod.post);
    return _parseActivityApplicationList(response.data);
  }

  static List<Class2ndActivityApplication> _parseActivityApplicationList(String htmlPage) {
    if (htmlPage.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>')) {
      debugPrint("My involved list needs refresh.");
      throw Exception("My involved list needs refresh.");
    }

    return BeautifulSoup(htmlPage)
        .findAll('#content-box > div:nth-child(23) > div.table_style_4 > form > table > tbody > tr')
        .map((e) => _activityMapDetail(e))
        .where(filterDeletedActivity)
        .toList();
  }

  static bool filterDeletedActivity(Class2ndActivityApplication x) => x.activityId != 0;

  static final attendedTimeFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  static Class2ndActivityApplication _activityMapDetail(Bs4Element item) {
    final applyIdText = item.find('td:nth-child(1)')!.text.trim();
    final applyId = int.parse(applyIdText);
    final activityIdText = item.find('td:nth-child(3)')!.innerHtml.trim();
    // 部分取消了的活动，活动链接不存在，这里将活动 id 记为 -1.
    final activityId = int.parse(activityIdRe.firstMatch(activityIdText)?.group(1) ?? '-1');
    final String title = item.find('td:nth-child(3)')!.text.trim();
    final DateTime time = attendedTimeFormat.parse(item.find('td:nth-child(7)')!.text.trim());
    final String status = item.find('td:nth-child(9)')!.text.trim();

    return Class2ndActivityApplication(
      applyId: applyId,
      activityId: activityId,
      title: title,
      time: time,
      status: status,
    );
  }
}
