import 'package:hive_flutter/hive_flutter.dart';

import 'adapter.dart';

class HiveInit {
  const HiveInit._();

  static late Box credentials;
  static late Box library;
  static late Box timetable;
  static late Box expense;
  static late Box yellowPages;
  static late Box class2nd;
  static late Box examArrange;
  static late Box examResult;
  static late Box oaAnnounce;
  static late Box ywb;
  static late Box eduEmail;
  static late Box settings;
  static late Box meta;
  static late Box cookies;

  static late Map<String, Box> name2Box;
  static late List<Box> cacheBoxes;

  static Future<void> init(String root) async {
    await Hive.initFlutter(root);
    HiveAdapter.registerAll();
    name2Box = _name2Box([
      credentials = await Hive.openBox('credentials'),
      settings = await Hive.openBox('settings'),
      meta = await Hive.openBox('meta'),
      yellowPages = await Hive.openBox('yellow-pages'),
      timetable = await Hive.openBox('timetable'),
      ...cacheBoxes = [
        eduEmail = await Hive.openBox('edu-email'),
        cookies = await Hive.openBox('cookies'),
        expense = await Hive.openBox('expense'),
        library = await Hive.openBox('library'),
        examArrange = await Hive.openBox('exam-arrange'),
        examResult = await Hive.openBox('exam-result'),
        oaAnnounce = await Hive.openBox('oa-announce'),
        class2nd = await Hive.openBox('class2nd'),
        ywb = await Hive.openBox('ywb'),
      ],
    ]);
  }

  static Map<String, Box> _name2Box(List<Box> boxes) {
    final map = <String, Box>{};
    for (final box in boxes) {
      map[box.name] = box;
    }
    return map;
  }

  static Future<void> clear() async {
    for (final box in name2Box.values) {
      await box.clear();
    }
  }

  static Future<void> clearCache() async {
    for (final box in cacheBoxes) {
      await box.clear();
    }
  }
}
