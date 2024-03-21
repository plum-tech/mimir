import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:sit/entity/version.dart';

class R {
  const R._();

  static const scheme = "life.mysit";
  static const hiveStorageVersionCache = "2.3.0";
  static const hiveStorageVersionCore = "2.1.1";
  static const appId = "life.mysit.SITLife";
  static const appName = "SIT Life";
  static const icpLicense = "沪ICP备18042337号-3A";

  static String get appNameL10n => "appName".tr();

  static late AppMeta currentVersion;

  /// For debugging iOS on other platforms.
  static const debugCupertino = kDebugMode ? true : false;

  /// The default window size is small enough for any modern desktop device.
  static const Size defaultWindowSize = Size(500, 800);

  /// If the window was resized to too small accidentally, this will keep a minimum function area.
  static const Size minWindowSize = Size(300, 400);

  static const eduEmailDomain = "mail.sit.edu.cn";
  static const demoModeOaAccount = "2300421153";
  static const demoModeOaPassword = "liplum-sit-life";

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

  static final jwxtUri = Uri(scheme: "http", host: "jwxt.sit.edu.cn");
  static final authServerUri = Uri(scheme: "https", host: "authserver.sit.edu.cn");
  static final class2ndUri = Uri(scheme: "http", host: "sc.sit.edu.cn");
  static final schoolCardUri = Uri(scheme: "http", host: "card.sit.edu.cn");
  static final myPortalUri = Uri(scheme: "https", host: "myportal.sit.edu.cn");
  static final libraryUri = Uri(scheme: "http", host: "210.35.66.106");
  static final gateUri = Uri(scheme: "http", host: "210.35.98.178");
  static final sitUriList = [
    authServerUri,
    jwxtUri,
    class2ndUri,
    schoolCardUri,
    myPortalUri,
    libraryUri,
  ];
  static final sitSchoolNetworkUriList = [
    jwxtUri,
    class2ndUri,
    schoolCardUri,
    libraryUri,
    gateUri,
  ];
}
