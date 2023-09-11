import 'package:intl/intl.dart';

abstract class _RegionalFormatter {
  DateFormat get ymdText;

  DateFormat get ymdWeekText;

  DateFormat get ymText;

  DateFormat get ymdNum;

  DateFormat get ymdhmsNum;

  DateFormat get mdHmNum;
}

class Lang {
  Lang._();

  static const zh = "zh";
  static const zhTw = "zh_TW";
  static const tw = "TW";
  static const en = "en";

  static final zhFormatter = _ZhFormatter();
  static final zhTwFormatter = _ZhTwFormatter();
  static final enFormatter = _EnFormatter();
  static final hms = DateFormat("H:mm:ss");

  static _RegionalFormatter _getFormatterFrom(String lang, String? country) {
    if (lang == zh) {
      if (country == null) {
        return zhFormatter;
      } else if (country == tw) {
        return zhTwFormatter;
      }
    } else if (lang == en) {
      return enFormatter;
    }
    return zhFormatter;
  }

  static DateFormat ymdWeekText(String lang, String? country) => _getFormatterFrom(lang, country).ymdWeekText;

  static DateFormat formatYmdText(String lang, String? country) => _getFormatterFrom(lang, country).ymdText;

  static DateFormat ymdNum(String lang, String? country) => _getFormatterFrom(lang, country).ymdNum;

  static DateFormat ymText(String lang, String? country) => _getFormatterFrom(lang, country).ymText;

  static DateFormat ymdhmsNum(String lang, String? country) => _getFormatterFrom(lang, country).ymdhmsNum;

  static DateFormat mdHmNum(String lang, String? country) => _getFormatterFrom(lang, country).mdHmNum;
}

class _ZhFormatter implements _RegionalFormatter {
  @override
  final ymdText = DateFormat("yyyy年M月d日", "zh_CN");
  @override
  final ymdWeekText = DateFormat("yyyy年M月d日 EEEE", "zh_CN");
  @override
  final ymText = DateFormat("yyyy年M月", "zh_CN");
  @override
  final ymdNum = DateFormat("yyyy/M/d", "zh_CN");
  @override
  final ymdhmsNum = DateFormat("yyyy/MM/dd H:mm:ss", "zh_CN");
  @override
  final mdHmNum = DateFormat("M/d H:m", "zh_CN");
}

class _ZhTwFormatter implements _RegionalFormatter {
  @override
  final ymdText = DateFormat("yyyy年M月d日", "zh_TW");
  @override
  final ymdWeekText = DateFormat("yyyy年M月d日 EEEE", "zh_TW");
  @override
  final ymText = DateFormat("yyyy年M月", "zh_TW");
  @override
  final ymdNum = DateFormat("yyyy/M/d", "zh_TW");
  @override
  final ymdhmsNum = DateFormat("yyyy/M/d H:mm:ss", "zh_TW");
  @override
  final mdHmNum = DateFormat("M/d H:m", "zh_TW");
}

class _EnFormatter implements _RegionalFormatter {
  @override
  final ymdText = DateFormat("MMMM d, yyyy", "en_US");
  @override
  final ymdWeekText = DateFormat("EEEE, MMMM d, yyyy", "en_US");
  @override
  final ymText = DateFormat("MMMM, yyyy", "en_US");
  @override
  final ymdNum = DateFormat("M/d/yyyy", "en_US");
  @override
  final ymdhmsNum = DateFormat("M/d/yyyy H:mm:ss", "en_US");
  @override
  final mdHmNum = DateFormat("M/d H:m", "en_US");
}
