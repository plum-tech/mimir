import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:sit/settings/meta.dart';
import 'package:sit/settings/settings.dart';
import "package:hive/src/hive_impl.dart";
import 'adapter.dart';

class HiveInit {
  const HiveInit._();

  static final core = HiveImpl();
  static final cache = HiveImpl();

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

  static Future<void> init({
    required Directory coreDir,
    required Directory cacheDir,
  }) async {
    debugPrint("Initializing hive");
    await core.initFlutter(coreDir);
    await cache.initFlutter(cacheDir);

    HiveAdapter.registerCoreAdapters(core);
    HiveAdapter.registerCacheAdapters(cache);
  }

  static Future<void> initBox() async {
    debugPrint("Initializing hive box");
    name2Box = _name2Box([
      credentials = await core.openBox('credentials'),
      settings = await core.openBox('settings'),
      meta = await core.openBox('meta'),
      timetable = await core.openBox('timetable'),
      ...cacheBoxes = [
        yellowPages = await cache.openBox('yellow-pages'),
        eduEmail = await cache.openBox('edu-email'),
        cookies = await cache.openBox('cookies'),
        expense = await cache.openBox('expense'),
        library = await cache.openBox('library'),
        examArrange = await cache.openBox('exam-arrange'),
        examResult = await cache.openBox('exam-result'),
        oaAnnounce = await cache.openBox('oa-announce'),
        class2nd = await cache.openBox('class2nd'),
        ywb = await cache.openBox('ywb'),
        electricity = await cache.openBox('electricity'),
      ],
    ]);
    Settings = SettingsImpl(settings);
    Meta = MetaImpl(meta);
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
extension HiveX on HiveInterface {
  /// Initializes Hive with the path from [getApplicationDocumentsDirectory].
  ///
  /// You can provide a [subDir] where the boxes should be stored.
  Future<void> initFlutter(Directory dir) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) return;
    init(dir.path);
  }

  void addAdapter<T>(TypeAdapter<T> adapter) {
    if (!isAdapterRegistered(adapter.typeId)) {
      registerAdapter<T>(adapter);
    }
  }
}
