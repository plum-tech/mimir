import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mimir/module/activity/page/util.dart';

import '../dao/list.dart';
import '../entity/list.dart';
import '../using.dart';

class ScActivityListService implements ScActivityListDao {
  static const _scActivityType = {
    ActivityType.schoolCulture: '8ab17f543fe626a8013fe6278a880001',
    ActivityType.creation: 'ff8080814e241104014eb867e1481dc3',
    ActivityType.lecture: '001',
    ActivityType.practice: '8ab17f543fe62d5d013fe62efd3a0002',
    ActivityType.thematicEdu: 'ff808081674ec4720167ce60dda77cea',
    ActivityType.voluntary: '8ab17f543fe62d5d013fe62e6dc70001',
  };
  static RegExp re = RegExp(r"(\d){7}");
  static String selector = '.ul_7 li > a';
  static DateFormat dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');

  static bool _initializedCookie = false;

  final ISession session;

  const ScActivityListService(this.session);

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
  @override
  Future<List<Activity>> getActivityList(ActivityType type, int page) async {
    String generateUrl(ActivityType category, int page, [int pageSize = 20]) {
      return 'http://sc.sit.edu.cn/public/activity/activityList.action?pageNo=$page&pageSize=$pageSize&categoryId=${_scActivityType[category]}';
    }

    await _refreshCookie();
    final url = generateUrl(type, page);
    final response = await session.request(url, ReqMethod.get);

    return _parseActivityList(response.data);
  }

  @override
  Future<List<Activity>> query(String queryString) async {
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

  static List<Activity> _parseActivityList(String htmlPage) {
    if (htmlPage.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>')) {
      Log.info("Activity list needs refresh.");
      throw Exception("Activity list needs refresh.");
    }
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<Activity> result = soup.findAll(selector).map(
      (element) {
        final date = element.nextSibling!.text;
        final String title = element.text.substring(2);
        final String link = element.attributes['href']!;

        final String? x = re.firstMatch(link)?.group(0).toString();
        final int id = int.parse(x!);
        final titleAndTags = splitTitleAndTags(title);
        return Activity.named(
            id: id,
            category: ActivityType.unknown,
            title: title,
            ts: dateFormatParser.parse(date),
            realTitle: titleAndTags.title,
            tags: titleAndTags.tags);
      },
    ).toList();
    return result;
  }
}
