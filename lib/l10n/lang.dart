import 'package:intl/intl.dart';

abstract class _RegionalFormatter {
  DateFormat get ymdText;

  DateFormat get ymdWeekText;

  DateFormat get mdWeekText;

  DateFormat get ymText;

  DateFormat get ymdNum;

  DateFormat get ymdhmsNum;

  DateFormat get ymdhmNum;

  DateFormat get mdHmNum;

  DateFormat get mdNum;
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
  static final hm = DateFormat("H:mm");

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

  static DateFormat mdWeekText(String lang, String? country) => _getFormatterFrom(lang, country).mdWeekText;

  static DateFormat formatYmdText(String lang, String? country) => _getFormatterFrom(lang, country).ymdText;

  static DateFormat ymdNum(String lang, String? country) => _getFormatterFrom(lang, country).ymdNum;

  static DateFormat ymText(String lang, String? country) => _getFormatterFrom(lang, country).ymText;

  static DateFormat ymdhmsNum(String lang, String? country) => _getFormatterFrom(lang, country).ymdhmsNum;

  static DateFormat ymdhmNum(String lang, String? country) => _getFormatterFrom(lang, country).ymdhmNum;

  static DateFormat mdHmNum(String lang, String? country) => _getFormatterFrom(lang, country).mdHmNum;

  static DateFormat mdNum(String lang, String? country) => _getFormatterFrom(lang, country).mdNum;
}

class _ZhFormatter implements _RegionalFormatter {
  @override
  final ymdText = DateFormat("yyyy年M月d日", "zh_CN");
  @override
  final ymdWeekText = DateFormat("yyyy年M月d日 EEEE", "zh_CN");
  @override
  final mdWeekText = DateFormat("M月d日 EEEE", "zh_CN");
  @override
  final ymText = DateFormat("yyyy年M月", "zh_CN");
  @override
  final ymdNum = DateFormat("yyyy/M/d", "zh_CN");
  @override
  final ymdhmsNum = DateFormat("yyyy/M/d H:mm:ss", "zh_CN");
  @override
  final ymdhmNum = DateFormat("yyyy/M/d H:mm:ss", "zh_CN");
  @override
  final mdHmNum = DateFormat("M/d H:mm", "zh_CN");
  @override
  final mdNum = DateFormat("M/d", "zh_CN");
}

class _ZhTwFormatter implements _RegionalFormatter {
  @override
  final ymdText = DateFormat("yyyy年M月d日", "zh_TW");
  @override
  final ymdWeekText = DateFormat("yyyy年M月d日 EEEE", "zh_TW");
  @override
  final mdWeekText = DateFormat("M月d日 EEEE", "zh_TW");
  @override
  final ymText = DateFormat("yyyy年M月", "zh_TW");
  @override
  final ymdNum = DateFormat("yyyy/M/d", "zh_TW");
  @override
  final ymdhmsNum = DateFormat("yyyy/M/d H:mm:ss", "zh_TW");
  @override
  final ymdhmNum = DateFormat("yyyy/M/d H:mm:ss", "zh_TW");
  @override
  final mdHmNum = DateFormat("M/d H:mm", "zh_TW");
  @override
  final mdNum = DateFormat("M/d", "zh_TW");
}

// TODO: Using AM and PM
class _EnFormatter implements _RegionalFormatter {
  @override
  final ymdText = DateFormat("MMMM d, yyyy", "en_US");
  @override
  final ymdWeekText = DateFormat("EEEE, MMMM d, yyyy", "en_US");
  @override
  final mdWeekText = DateFormat("EEEE, MMMM d", "en_US");
  @override
  final ymText = DateFormat("MMMM, yyyy", "en_US");
  @override
  final ymdNum = DateFormat("M/d/yyyy", "en_US");
  @override
  final ymdhmsNum = DateFormat("M/d/yyyy H:mm:ss", "en_US");
  @override
  final ymdhmNum = DateFormat("M/d/yyyy H:mm", "en_US");
  @override
  final mdHmNum = DateFormat("M/d H:mm", "en_US");
  @override
  final mdNum = DateFormat("M/d", "en_US");
}
