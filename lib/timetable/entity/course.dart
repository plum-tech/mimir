import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

/// 课表显示模式
enum DisplayMode {
  daily,
  weekly;

  static DisplayMode? at(int? index) {
    if (index == null) {
      return null;
    } else if (0 <= index && index < DisplayMode.values.length) {
      return DisplayMode.values[index];
    }
    return null;
  }

  DisplayMode toggle() => DisplayMode.values[(index + 1) & 1];
}

@JsonSerializable(createToJson: false)
class Course {
  static final Map<String, int> _weekMapping = {'星期一': 1, '星期二': 2, '星期三': 3, '星期四': 4, '星期五': 5, '星期六': 6, '星期日': 7};

  /// 课程名称
  @JsonKey(name: 'kcmc')
  final String courseName;

  /// 星期
  @JsonKey(name: 'xqjmc', fromJson: _day2Index)
  final int dayIndex;

  /// 节次
  @JsonKey(name: 'jcs', fromJson: _time2Index)
  final int timeIndex;

  /// 周次 （原始文本）
  @JsonKey(name: 'zcd')
  final String weekText;

  /// 周次
  @JsonKey(includeFromJson: false)
  int weekIndex = 0;

  /// 持续时长 (节)
  @JsonKey(includeFromJson: false)
  int duration = 0;

  /// 教室
  @JsonKey(name: 'cdmc')
  final String place;

  /// 教师
  @JsonKey(name: 'xm', fromJson: _parseTeacherList, defaultValue: [])
  final List<String> teacher;

  /// 校区
  @JsonKey(name: 'xqmc')
  final String campus;

  /// 学分
  @JsonKey(name: 'xf', fromJson: _string2Double)
  final double credit;

  /// 学时
  @JsonKey(name: 'zxs', fromJson: _stringToInt)
  final int hour;

  /// 教学班
  @JsonKey(name: 'jxbmc', fromJson: _trim)
  final String dynClassId;

  /// 课程代码
  @JsonKey(name: 'kch')
  final String courseId;

  Course(this.courseName, this.dayIndex, this.timeIndex, this.place, this.teacher, this.campus, this.credit, this.hour,
      this.dynClassId, this.courseId, this.weekText)
      : weekIndex = _weekText2Index(weekText),
        duration = _countOne(timeIndex);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  @override
  String toString() {
    return '{"courseName":"$courseName","day":"$dayIndex","timeIndex":"$timeIndex","week":"$weekIndex","place":"$place","teacher":"$teacher","campus":"$campus","credit":"$credit","hour":"$hour","dynClassId":"$dynClassId","courseId":"$courseId","weekText":"$weekText","duration":"$duration"}';
  }

  /// 将中文的星期转换为数字, 如 "星期四" -> 4. 如果出错, 返回 0
  static int _day2Index(String weekDay) => _weekMapping[weekDay] ?? 0;

  /// 将 [String?] 转为十进制整数. 如果出错, 返回 64.
  ///
  /// 如果返回 0, 后续 [_time2Index] 函数在遇到错误时会执行 2 << 0, 导致第 2 位被置为 1, 产生错误
  static int _parseInt(String? x) => int.tryParse(x ?? '64') ?? 64;

  /// 将逗号分隔的字符串转为列表
  static List<String> _parseTeacherList(String s) => s.split(',');

  /// 字符串转小数
  static double _string2Double(String s) => double.tryParse(s) ?? double.nan;

  /// 字符串转整数 (默认 0)
  static int _stringToInt(String s) => int.tryParse(s) ?? 0;

  /// 字符串去首尾空白字符
  static String _trim(String s) => s.trim();

  /// 判断 1 的个数
  static int _countOne(int n) {
    int count = 0;
    while (n != 0) {
      count += n & 1;
      n >>= 1;
    }
    return count;
  }

  /// 解析周数字符串为整数. 例：1-8周(单),2-7周,3周
  static int _weekText2Index(String text) {
    int result = 0;
    text.split(',').forEach((weekText) {
      final int step = weekText.endsWith('(单)') || weekText.endsWith('(双)') ? 2 : 1;
      final String text = weekText.split('周')[0];
      result |= _time2Index(text, step);
    });
    return result;
  }

  /// 解析时间字符串, 如 1-2、3
  static int _time2Index(String text, [int step = 1]) {
    if (!text.contains('-')) {
      return 1 << _parseInt(text);
    }
    int result = 0;
    final timeText = text.split('-');
    int min = _parseInt(timeText.first);
    int max = _parseInt(timeText.last);
    for (int i = min; i <= max; i += step) {
      result |= 1 << i;
    }
    return result;
  }
}

@JsonSerializable()
class CourseRaw {
  /// 课程名称
  @JsonKey(name: 'kcmc')
  final String courseName;

  /// 星期
  @JsonKey(name: 'xqjmc')
  final String weekDayText;

  /// 节次
  @JsonKey(name: 'jcs')
  final String timeslotsText;

  /// 周次
  @JsonKey(name: 'zcd')
  final String weekText;

  /// 教室
  @JsonKey(name: 'cdmc')
  final String place;

  /// 教师
  @JsonKey(name: 'xm', defaultValue: "")
  final String teachers;

  /// 校区
  @JsonKey(name: 'xqmc')
  final String campus;

  /// 学分
  @JsonKey(name: 'xf')
  final String courseCredit;

  /// 学时
  @JsonKey(name: 'zxs')
  final String creditHour;

  /// 教学班
  @JsonKey(name: 'jxbmc')
  final String classCode;

  /// 课程代码
  @JsonKey(name: 'kch')
  final String courseCode;

  factory CourseRaw.fromJson(Map<String, dynamic> json) => _$CourseRawFromJson(json);

  CourseRaw(this.courseName, this.weekDayText, this.timeslotsText, this.weekText, this.place, this.teachers,
      this.campus, this.courseCredit, this.creditHour, this.classCode, this.courseCode);
}
