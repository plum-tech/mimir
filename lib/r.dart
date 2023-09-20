import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mimir/school/yellow_pages/entity/contact.dart';
import 'package:version/version.dart';

class R {
  R._();

  static const debugCupertino = kDebugMode ? true : false;
  static const enLocale = Locale('en');
  static const zhCnLocale = Locale('zh', "CN");
  static const zhTwLocale = Locale('zh', "TW");
  static const defaultLocale = zhCnLocale;
  static const supportedLocales = [
    enLocale,
    zhCnLocale,
    zhTwLocale,
  ];
  static const appName = "Mimir";
  static late final String appDir;
  static late final String tmpDir;
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
