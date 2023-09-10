import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/school/library/search/entity/search_history.dart';

import 'adapter.dart';

class HiveBoxInit {
  const HiveBoxInit._();

  static late Box<dynamic> credentials;
  static late Box<LibrarySearchHistoryItem> librarySearchHistory;
  static late Box<dynamic> timetable;
  static late Box<dynamic> expense;
  static late Box<dynamic> yellowPages;
  static late Box<dynamic> activityCache;
  static late Box<dynamic> examArrCache;
  static late Box<dynamic> examResultCache;
  static late Box<dynamic> oaAnnounceCache;
  static late Box<dynamic> applicationCache;
  static late Box<dynamic> eduEmail;
  static late Box<dynamic> settings;
  static late Box<dynamic> meta;
  static late Box<dynamic> cookies;

  static late Map<String, Box> name2Box;
  static late List<Box> cacheBoxes;

  static Future<void> init(String root) async {
    await Hive.initFlutter(root);
    HiveAdapter.registerAll();
    name2Box = _name2Box([
      credentials = await Hive.openBox('credentials'),
      settings = await Hive.openBox('settings'),
      meta = await Hive.openBox('meta'),
      expense = await Hive.openBox('expense'),
      yellowPages = await Hive.openBox('yellow-pages'),
      librarySearchHistory = await Hive.openBox('library-search-history'),
      cookies = await Hive.openBox('cookies'),
      timetable = await Hive.openBox('timetable'),
      eduEmail = await Hive.openBox('eduEmail'),
      ...cacheBoxes = [
        examArrCache = await Hive.openBox('exam-arr-Cache'),
        examResultCache = await Hive.openBox('exam-result-cache'),
        oaAnnounceCache = await Hive.openBox('oa-announce-cache'),
        activityCache = await Hive.openBox('activity-cache'),
        applicationCache = await Hive.openBox('application-cache'),
      ],
    ]);
  }

  static Map<String, Box> _name2Box(List<Box<dynamic>> boxes) {
    final map = <String, Box>{};
    for (final box in boxes) {
      map[box.name] = box;
    }
    return map;
  }

  static Future<void> clear() async {
    for (final box in name2Box.values) {
      await box.deleteFromDisk();
    }
    await Hive.close();
  }

  static Future<void> clearCache() async {
    for (final box in cacheBoxes) {
      await box.clear();
    }
  }
}
