import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:sit/version.dart';
import 'package:version/version.dart';

class R {
  const R._();

  static const baseScheme = "sitlife";
  static const hiveStorageVersion = "1.0.0+13";
  static const appId = "life.mysit.SITLife";
  static const appName = "SIT Life";
  static final v1_0_0 = Version(1, 0, 0);
  static late AppVersion currentVersion;

  /// For debugging iOS on other platforms.
  static const debugCupertino = kDebugMode ? false : false;

  /// The default window size is small enough for any modern desktop device.
  static const Size defaultWindowSize = Size(500, 800);

  /// If the window was resized to too small accidentally, this will keep a minimum function area.
  static const Size minWindowSize = Size(300, 400);

  static const eduEmailDomain = "mail.sit.edu.cn";

  static String formatEduEmail({required String username}) {
    return "$username@$eduEmailDomain";
  }

  static late List<String> roomList;
  static late List<String> userAgentList;
  static late List<SchoolContact> yellowPages;
  static const enLocale = Locale('en');
  static const zhHansLocale = Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans");
  static const zhHantLocale = Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant");
  static const defaultLocale = zhHansLocale;
  static const supportedLocales = [
    enLocale,
    zhHansLocale,
    zhHantLocale,
  ];
}
