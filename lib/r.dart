import 'dart:ui';

import 'package:version/version.dart';

class R {
  R._();

  static const enLocale = Locale('en');
  static const zhCnLocale = Locale('zh', "CN");
  static const zhTwLocale = Locale('zh', "TW");
  static const defaultLocale = zhCnLocale;
  static const supportedLocales = [
    enLocale,
    zhCnLocale,
    zhTwLocale,
  ];
  static const kiteDomain = "https://kite.sunnysab.cn";
  static const appName = "Mimir";
  static const forgotLoginPwdUrl =
      "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";
  static const easyConnectDownloadUrl = "https://vpn1.sit.edu.cn/com/installClient.html";
  static const defaultThemeColor = Color(0xff2196f3);

  /// The default window size is small enough for any modern desktop device.
  static const Size defaultWindowSize = Size(500, 800);

  /// If the window was resized to too small accidentally, this will keep a minimum function area.
  static const Size minWindowSize = Size(300, 400);

  static final v1_0_0 = Version(1, 0, 0);
}

class CampusCode {
  CampusCode._();

  static const fengxian = 1;
  static const xuhui = 2;
}

class WeatherCode {
  WeatherCode._();

  /// campus 1
  @CampusCode.fengxian
  static const fengxian = "101021000";

  /// campus 2
  @CampusCode.xuhui
  static const xuhui = "101021200";

  static from({required int campus}) => campus == 1 ? fengxian : xuhui;
}
