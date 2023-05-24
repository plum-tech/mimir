import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/app.dart';

import '../global/global.dart';
import 'lang.dart';

export 'package:mimir/r.dart';

export 'lang.dart';

extension I18nBuildContext on BuildContext {
  ///e.g.: Wednesday, September 21, 2022
  String dateText(DateTime date) {
    final curLocale = locale;
    return Lang.dateT(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  ///e.g.: 9/21/2022
  String dateNum(DateTime date) {
    final curLocale = locale;
    return Lang.dateN(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  ///e.g.: 9/21/2022 23:57:23
  String dateFullNum(DateTime date) {
    final curLocale = locale;
    return Lang.fullN(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  String dateYearMonth(DateTime date) {
    final curLocale = locale;
    return Lang.ymT(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  /// e.g.: 8:32:59
  String dateTime(DateTime date) => Lang.timef.format(date);
}

extension LocaleExtension on Locale {
  String dateText(DateTime date) => DateFormat.yMMMMEEEEd(languageCode).format(date);
}

bool yOrNo(String test, {bool defaultValue = false}) {
  switch (test) {
    case "y":
      return true;
    case "n":
      return false;
    default:
      return defaultValue;
  }
}

///e.g.: Wednesday, September 21, 2022
/// [$Key.currentContext] is used
String dateText(DateTime date) {
  final curLocale = $Key.currentContext!.locale;
  return Lang.dateT(curLocale.languageCode, curLocale.countryCode).format(date);
}

///e.g.:9/21/2022
/// [$Key.currentContext] is used
String dateNum(DateTime date) {
  final curLocale = $Key.currentContext!.locale;
  return Lang.dateN(curLocale.languageCode, curLocale.countryCode).format(date);
}

///e.g.: 9/21/2022 23:57:23
/// [$Key.currentContext] is used
String dateFullNum(DateTime date) {
  final curLocale = $Key.currentContext!.locale;
  return Lang.fullN(curLocale.languageCode, curLocale.countryCode).format(date);
}
