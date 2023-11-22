import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/session/class2nd.dart';

import '../entity/list.dart';
import "package:intl/intl.dart";

class Class2ndActivityListService {
  static final re = RegExp(r"(\d){7}");
  static const selector = '.ul_7 li > a';
  static final dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');

  static bool _initializedCookie = false;

  Class2ndSession get session => Init.class2ndSession;

  const Class2ndActivityListService();

  Future<void> _refreshCookie() async {
    if (!_initializedCookie) {
      await session.request('http://sc.sit.edu.cn/', ReqMethod.get);
      _initializedCookie = true;
    }
  }

  String generateUrl(Class2ndActivityCat category, int page, [int pageSize = 20]) {
    return 'http://sc.sit.edu.cn/public/activity/activityList.action?pageNo=$page&pageSize=$pageSize&categoryId=${category.id}';
  }

  /// 获取第二课堂活动列表
  Future<List<Class2ndActivity>> getActivityList(Class2ndActivityCat type, int page) async {
    await _refreshCookie();
    final url = generateUrl(type, page);
    final response = await session.request(url, ReqMethod.get);
    return _parseActivityList(response.data);
  }

  Future<List<Class2ndActivity>> query(String queryString) async {
    const String url = 'http://sc.sit.edu.cn/public/activity/activityList.action';
    await _refreshCookie();
    final response = await session.request(
      url,
      ReqMethod.post,
      data: 'activityName=$queryString',
      options: SessionOptions(contentType: Headers.formUrlEncodedContentType),
    );

    return _parseActivityList(response.data);
  }

  static List<Class2ndActivity> _parseActivityList(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<Class2ndActivity> result = soup.findAll(selector).map(
      (element) {
        final date = element.nextSibling!.text;
        final String fullTitle = mapChinesePunctuations(element.text.substring(2));
        final String link = element.attributes['href']!;

        final String? x = re.firstMatch(link)?.group(0).toString();
        final int id = int.parse(x!);
        return Class2ndActivity(
          id: id,
          title: fullTitle,
          ts: dateFormatParser.parse(date),
        );
      },
    ).toList();
    return result;
  }
}
