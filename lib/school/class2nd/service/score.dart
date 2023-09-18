import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/sc.dart';

import '../entity/list.dart';
import '../entity/score.dart';

class Class2ndScoreService {
  static const _scHomeUrl = 'http://sc.sit.edu.cn/public/init/index.action';
  static const _scScoreUrl = 'http://sc.sit.edu.cn/public/pcenter/scoreDetail.action';
  static const _scMyEventUrl = 'http://sc.sit.edu.cn/public/pcenter/activityOrderList.action?pageSize=999';

  static const totalScore = '#content-box > div.user-info > div:nth-child(3) > font';
  static const spanScore = '#span_score';
  static const scoreDetailPage = '#div1 > div.table_style_4 > form > table:nth-child(7) > tbody > tr';
  static const idDetail = 'td:nth-child(7)';
  static const titleDetail = 'td:nth-child(3)';
  static const categoryDetail = 'td:nth-child(5)';
  static const scoreDetail = 'td:nth-child(11) > span';
  static const activityDetail = '#content-box > div:nth-child(23) > div.table_style_4 > form > table > tbody > tr';
  static const applyIdDetail = 'td:nth-child(1)';
  static const activityIdDetail = 'td:nth-child(3)';
  static const timeDetail = 'td:nth-child(7)';
  static const statusDetail = 'td:nth-child(9)';

  static final dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');
  static final activityIdRe = RegExp(r'activityId=(\d+)');

  final Class2ndSession session;

  const Class2ndScoreService(this.session);

  /// 获取第二课堂分数
  Future<Class2ndScoreSummary> fetchScoreSummary() async {
    final response = await session.request(_scHomeUrl, ReqMethod.post);
    final data = response.data;
    return _parseScScoreSummary(data);
  }

  static Class2ndScoreSummary _parseScScoreSummary(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);

    // 学分=1.5(主题报告)+2.0(社会实践)+1.5(创新创业创意)+1.0(校园安全文明)+0.0(公益志愿)+2.0(校园文化)
    final found = soup.find(spanScore)!;
    final String scoreText = found.text.toString();
    final regExp = RegExp(r'([\d.]+)\(([\u4e00-\u9fa5]+)\)');

    final matches = regExp.allMatches(scoreText);
    late final double lecture, practice, creation, safetyEdu, voluntary, campus;

    for (final item in matches) {
      final score = double.parse(item.group(1) ?? '0.0');
      final type = stringToActivityScoreType[item.group(2)]!;

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
        case ActivityScoreType.safetyCiviEdu:
          safetyEdu = score;
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
  Future<List<Class2ndScoreItem>> fetchScoreList() async {
    final response = await session.request(_scScoreUrl, ReqMethod.post);
    return _parseScoreList(response.data);
  }

  static List<Class2ndScoreItem> _parseScoreList(String htmlPage) {
    if (htmlPage.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>')) {
      debugPrint("My score list needs refresh.");
      throw Exception("My score list needs refresh.");
    }
    Class2ndScoreItem nodeToScoreItem(Bs4Element item) {
      final int id = int.parse(item.find(idDetail)!.innerHtml.trim());
      // 注意：“我的成绩” 页面中，成绩条目显示的是活动类型，而非加分类型, 因此使用 ActivityType.
      final Class2ndActivityCat category = stringToActivityType[item.find(categoryDetail)!.innerHtml.trim()]!;
      final double amount = double.parse(item.find(scoreDetail)!.innerHtml.trim());

      return Class2ndScoreItem(id, category, amount);
    }

    // 得分列表里面，有一些条目加诚信分，此时常规得分为 0, 要把这些条目过滤掉。
    bool filterZeroScore(Class2ndScoreItem item) => item.amount > 0.01;

    return BeautifulSoup(htmlPage).findAll(scoreDetailPage).map(nodeToScoreItem).where(filterZeroScore).toList();
  }

  /// 获取我的活动列表
  Future<List<Class2ndActivityApplication>> fetchAttended() async {
    final response = await session.request(_scMyEventUrl, ReqMethod.post);
    return _parseAttendedActivityList(response.data);
  }

  static List<Class2ndActivityApplication> _parseAttendedActivityList(String htmlPage) {
    if (htmlPage.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>')) {
      debugPrint("My involved list needs refresh.");
      throw Exception("My involved list needs refresh.");
    }
    Class2ndActivityApplication _activityMapDetail(Bs4Element item) {
      final applyIdText = item.find(applyIdDetail)!.text.trim();
      final applyId = int.parse(applyIdText);
      final activityIdText = item.find(activityIdDetail)!.innerHtml.trim();
      // 部分取消了的活动，活动链接不存在，这里将活动 id 记为 -1.
      final activityId = int.parse(activityIdRe.firstMatch(activityIdText)?.group(1) ?? '-1');
      final String title = item.find(titleDetail)!.text.trim();
      final DateTime time = dateFormatParser.parse(item.find(timeDetail)!.text.trim());
      final String status = item.find(statusDetail)!.text.trim();

      return Class2ndActivityApplication(
        applyId: applyId,
        activityId: activityId,
        title: title,
        time: time,
        status: status,
      );
    }

    bool _filterDeletedActivity(Class2ndActivityApplication x) => x.activityId != 0;

    return BeautifulSoup(htmlPage)
        .findAll(activityDetail)
        .map((e) => _activityMapDetail(e))
        .where((element) => _filterDeletedActivity(element))
        .toList();
  }
}
