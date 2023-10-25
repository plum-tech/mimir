import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:version/version.dart';

class R {
  R._();

  static const debugCupertino = kDebugMode ? _debugCupertino : false;

  static const baseScheme = "sitlife";

  /// For debugging iOS on other platforms.
  static const _debugCupertino = false;
  static const enLocale = Locale('en');
  static const zhCnLocale = Locale('zh', "CN");
  static const zhTwLocale = Locale('zh', "TW");
  static const defaultLocale = zhCnLocale;
  static const supportedLocales = [
    enLocale,
    zhCnLocale,
    zhTwLocale,
  ];
  static const appId = "life.mysit.SITLife";
  static const appName = "SIT Life";
  static late final Directory appDir;
  static late final Directory tmpDir;
  static late List<String> roomList;
  static late List<String> userAgents;

  static late List<SchoolContact> yellowPages;

  /// The default window size is small enough for any modern desktop device.
  static const Size defaultWindowSize = Size(500, 800);

  /// If the window was resized to too small accidentally, this will keep a minimum function area.
  static const Size minWindowSize = Size(300, 400);

  static final v1_0_0 = Version(1, 0, 0);

  static const eduEmailDomain = "mail.sit.edu.cn";

  static String formatEduEmail({required String username}) {
    return "$username@$eduEmailDomain";
  }
}
