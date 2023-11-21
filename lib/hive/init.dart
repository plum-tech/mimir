import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:sit/settings/meta.dart';
import 'package:sit/settings/settings.dart';

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
  static late Box electricity;
  static late Box meta;
  static late Box cookies;

  static late Map<String, Box> name2Box;
  static late List<Box> cacheBoxes;

  static Future<void> init(Directory dir) async {
    debugPrint("Initializing hive");
    await Hive.initFlutter(dir);
    HiveAdapter.registerAll();
  }
  static Future<void> initBox() async {
    debugPrint("Initializing hive box");
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
        electricity = await Hive.openBox('electricity'),
      ],
    ]);
    Settings = SettingsImpl(HiveInit.settings);
    Meta = MetaImpl(HiveInit.meta);
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

/// Flutter extensions for Hive.
extension _HiveX on HiveInterface {
  /// Initializes Hive with the path from [getApplicationDocumentsDirectory].
  ///
  /// You can provide a [subDir] where the boxes should be stored.
  Future<void> initFlutter(Directory dir) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) return;
    init(dir.path);
  }
}
