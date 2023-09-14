import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mimir/network/session.dart';

import '../entity/list.dart';
import '../utils.dart';
import "package:intl/intl.dart";

class Class2ndActivityListService {
  static const _scActivityType = {
    Class2ndActivityCat.schoolCulture: '8ab17f543fe626a8013fe6278a880001',
    Class2ndActivityCat.creation: 'ff8080814e241104014eb867e1481dc3',
    Class2ndActivityCat.lecture: '001',
    Class2ndActivityCat.practice: '8ab17f543fe62d5d013fe62efd3a0002',
    Class2ndActivityCat.thematicEdu: 'ff808081674ec4720167ce60dda77cea',
    Class2ndActivityCat.voluntary: '8ab17f543fe62d5d013fe62e6dc70001',
  };
  static final re = RegExp(r"(\d){7}");
  static const selector = '.ul_7 li > a';
  static final dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');

  static bool _initializedCookie = false;

  final ISession session;

  const Class2ndActivityListService(this.session);

  Future<void> _refreshCookie() async {
    Future<void> getHomePage() async {
      const String url = 'http://sc.sit.edu.cn/';
      await session.request(url, ReqMethod.get);
    }

    if (!_initializedCookie) {
      await getHomePage();
      _initializedCookie = true;
    }
  }

  /// 获取第二课堂活动列表
  Future<List<Class2ndActivity>> getActivityList(Class2ndActivityCat type, int page) async {
    String generateUrl(Class2ndActivityCat category, int page, [int pageSize = 20]) {
      return 'http://sc.sit.edu.cn/public/activity/activityList.action?pageNo=$page&pageSize=$pageSize&categoryId=${_scActivityType[category]}';
    }

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
    if (htmlPage.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>')) {
      debugPrint("Activity list needs refresh.");
      throw Exception("Activity list needs refresh.");
    }
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<Class2ndActivity> result = soup.findAll(selector).map(
      (element) {
        final date = element.nextSibling!.text;
        final String title = element.text.substring(2);
        final String link = element.attributes['href']!;

        final String? x = re.firstMatch(link)?.group(0).toString();
        final int id = int.parse(x!);
        final titleAndTags = splitTitleAndTags(title);
        return Class2ndActivity.named(
            id: id,
            category: Class2ndActivityCat.unknown,
            title: title,
            ts: dateFormatParser.parse(date),
            realTitle: titleAndTags.title,
            tags: titleAndTags.tags);
      },
    ).toList();
    return result;
  }
}
