import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/school/utils.dart';
import 'package:sit/session/class2nd.dart';

import '../entity/details.dart';
import '../entity/list.dart';
import "package:intl/intl.dart";

class Class2ndActivityService {
  static final re = RegExp(r"(\d){7}");
  static final _spacesRx = RegExp(r'\s{2}\s+');
  static final dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');

  Class2ndSession get session => Init.class2ndSession;

  const Class2ndActivityService();

  String generateUrl(Class2ndActivityCat category, int page, [int pageSize = 20]) {
    return 'http://sc.sit.edu.cn/public/activity/activityList.action?pageNo=$page&pageSize=$pageSize&categoryId=${category.id}';
  }

  /// 获取第二课堂活动列表
  Future<List<Class2ndActivity>> getActivityList(Class2ndActivityCat type, int page) async {
    final url = generateUrl(type, page);
    final response = await session.request(
      url,
      options: Options(
        method: "GET",
      ),
    );
    return _parseActivityList(response.data);
  }

  Future<List<Class2ndActivity>> query(String queryString) async {
    const String url = 'http://sc.sit.edu.cn/public/activity/activityList.action';
    final response = await session.request(
      url,
      data: 'activityName=$queryString',
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        method: "POST",
      ),
    );

    return _parseActivityList(response.data);
  }

  static List<Class2ndActivity> _parseActivityList(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<Class2ndActivity> result = soup.findAll('.ul_7 li > a').map(
      (element) {
        final date = element.nextSibling!.text;
        final String fullTitle = mapChinesePunctuations(element.text.substring(2));
        final String link = element.attributes['href']!;

        final String? x = re.firstMatch(link)?.group(0).toString();
        final int id = int.parse(x!);
        return Class2ndActivity(
          id: id,
          title: fullTitle,
          time: dateFormatParser.parse(date),
        );
      },
    ).toList();
    return result;
  }

  /// 获取第二课堂活动详情
  Future<Class2ndActivityDetails> getActivityDetails(int activityId) async {
    final response = await session.request(
      'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=$activityId',
      options: Options(
        method: "POST",
      ),
    );
    final data = response.data;
    return _parseActivityDetails(data);
  }

  static String _cleanText(String banner) {
    String result = banner.replaceAll('&nbsp;', ' ').replaceAll('<br>', '');
    return result.replaceAll(_spacesRx, '\n');
  }

  static Map<String, String> _splitActivityProperties(String banner) {
    String cleanText = _cleanText(banner);
    List<String> lines = cleanText.split('\n');
    lines.removeLast();
    final map = <String, String>{};
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
    String title = item.findAll('h1').map((e) => e.innerHtml.trim()).elementAt(0);
    String description =
        item.findAll('div[style="padding:30px 50px; font-size:14px;"]').map((e) => e.innerHtml.trim()).elementAt(0);
    String banner =
        item.findAll('div[style=" color:#7a7a7a; text-align:center"]').map((e) => e.innerHtml.trim()).elementAt(0);

    final properties = _splitActivityProperties(banner);
    final signTime = _parseSignTime(properties['刷卡时间段']!);

    return Class2ndActivityDetails(
      id: int.parse(properties['活动编号']!),
      title: mapChinesePunctuations(title),
      startTime: _parseDateTime(properties['活动开始时间']!),
      signStartTime: signTime[0],
      signEndTime: signTime[1],
      place: properties['活动地点'],
      duration: properties['活动时长'],
      principal: properties['负责人'],
      contactInfo: properties['负责人电话'],
      organizer: properties['主办方'],
      undertaker: properties['承办方'],
      description: description,
    );
  }

  static Class2ndActivityDetails _parseActivityDetails(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final frame = soup.find('.box-1');
    final detail = _parseProperties(frame!);

    return detail;
  }
}
