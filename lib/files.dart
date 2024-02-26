import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:universal_platform/universal_platform.dart';

class Files {
  const Files._();

  static late final Directory temp;
  static late final Directory cache;
  static late final Directory internal;
  static late final Directory user;

  static Directory get screenshot => temp.subDir("screenshot");
  static Directory get artifact => temp.subDir("artifact");

  static const timetable = TimetableFiles();
  static const oaAnnounce = OaAnnounceFiles();

  static Future<void> init() async {
    if (kIsWeb) return;
    await screenshot.create(recursive: true);
    await artifact.create(recursive: true);
    await timetable.init();
  }
}

extension DirectoryX on Directory {
  File subFile(String p1, [String? p2, String? p3, String? p4]) => File(join(path, p1, p2, p3, p4));

  Directory subDir(String p1, [String? p2, String? p3, String? p4]) => Directory(join(path, p1, p2, p3, p4));
}

class TimetableFiles {
  const TimetableFiles();

  File get screenshotFile => Files.screenshot.subFile("timetable.png");

  File get backgroundFile => Files.user.subFile("timetable", "background.png");

  // on MIUI, OpenFile can't open file under `Files.user`
  Directory get calendarDir => (UniversalPlatform.isAndroid ? Files.cache : Files.user).subDir("timetable", "calendar");

  Future<void> init() async {
    await calendarDir.create(recursive: true);
    await Files.user.subDir("timetable").create(recursive: true);
  }
}

class OaAnnounceFiles {
  const OaAnnounceFiles();

  Directory attachmentDir(String uuid) => Files.internal.subDir("attachment", uuid);

  Future<void> init() async {}
}
