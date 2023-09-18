import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/sc.dart';

import '../entity/details.dart';

class Class2ndActivityDetailsService {
  static const _scDetailUrlBase = 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=';

  static RegExp reSpaces = RegExp(r'\s{2}\s+');
  static String selectorFrame = '.box-1';
  static String selectorTitle = 'h1';
  static String selectorBanner = 'div[style=" color:#7a7a7a; text-align:center"]';
  static String selectorDescription = 'div[style="padding:30px 50px; font-size:14px;"]';

  final Class2ndSession session;

  const Class2ndActivityDetailsService(this.session);

  /// 获取第二课堂活动详情
  Future<Class2ndActivityDetails> getActivityDetails(int activityId) async {
    final response = await session.request(_scDetailUrlBase + activityId.toString(), ReqMethod.post);
    final data = response.data;
    return _parseActivityDetail(data);
  }

  static String _cleanText(String banner) {
    String result = banner.replaceAll('&nbsp;', ' ').replaceAll('<br>', '');
    return result.replaceAll(reSpaces, '\n');
  }

  static HashMap<String, String> _splitActivityProperties(String banner) {
    String cleanText = _cleanText(banner);
    List<String> lines = cleanText.split('\n');
    lines.removeLast();
    HashMap<String, String> map = HashMap<String, String>();
    for (String line in lines) {
      List<String> result = line.split('：');
      map.addAll({result[0]: result[1]});
    }
    return map;
  }

  static DateTime _parseDateTime(String dateTime) {
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    return dateFormat.parse(dateTime);
  }

  static List<DateTime> _parseSignTime(String value) {
    List<String> time = value.split('  --至--  ');
    return [_parseDateTime(time[0]), _parseDateTime(time[1])];
  }

  static Class2ndActivityDetails _parseProperties(Bs4Element item) {
    String title = item.findAll(selectorTitle).map((e) => e.innerHtml.trim()).elementAt(0);
    String description = item.findAll(selectorDescription).map((e) => e.innerHtml.trim()).elementAt(0);
    String banner = item.findAll(selectorBanner).map((e) => e.innerHtml.trim()).elementAt(0);

    final properties = _splitActivityProperties(banner);
    final signTime = _parseSignTime(properties['刷卡时间段']!);

    return Class2ndActivityDetails.named(
        id: int.parse(properties['活动编号']!),
        category: 0,
        title: title,
        startTime: _parseDateTime(properties['活动开始时间']!),
        signStartTime: signTime[0],
        signEndTime: signTime[1],
        place: properties['活动地点'],
        duration: properties['活动时长'],
        principal: properties['负责人'],
        contactInfo: properties['负责人电话'],
        organizer: properties['主办方'],
        undertaker: properties['承办方'],
        description: description);
  }

  static Class2ndActivityDetails _parseActivityDetail(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final frame = soup.find(selectorFrame);
    final detail = _parseProperties(frame!);

    return detail;
  }
}
