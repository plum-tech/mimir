import 'package:easy_localization/easy_localization.dart';
import 'package:sit/hive/type_id.dart';
import 'package:sit/l10n/common.dart';

part 'school.g.dart';

typedef SchoolYear = int;

@HiveType(typeId: HiveTypeSchool.semester)
enum Semester {
  @HiveField(0)
  all,
  @HiveField(1)
  term1,
  @HiveField(2)
  term2;

  String localized() => "school.semester.$name".tr();
}

typedef SemesterInfo = ({SchoolYear year, Semester semester});

String semesterToFormField(Semester semester) {
  const mapping = {
    Semester.all: '',
    Semester.term1: '3',
    Semester.term2: '12',
  };
  return mapping[semester]!;
}

Semester formFieldToSemester(String s) {
  Map<String, Semester> semester = {
    '': Semester.all,
    '3': Semester.term1,
    '12': Semester.term2,
  };
  return semester[s]!;
}

SchoolYear formFieldToSchoolYear(String s) {
  return int.parse(s.split('-')[0]);
}

String schoolYearToFormField(SchoolYear year) {
  return '$year-${year + 1}';
}

double stringToDouble(String s) => double.tryParse(s) ?? double.nan;

class CourseCategory {
  static const Map<String, List<String>> _courseToCategory = {
    'art': [
      '手绘',
      '速写',
      '插图',
      '图文',
      '创作',
      '摄影',
      '构图',
      '美术',
      '水彩',
      '油画',
      '素描',
      '艺术',
      '雕塑',
      '装饰',
      '写生',
      '技法',
      '视觉',
      '漆艺',
      'UI',
      '广告',
      '美学'
    ],
    'biological': ['生物', '环境', '花卉', '药物', '微生物', '材料'],
    'history': ['文化', '历史', '设计史', '书画', '文明史'],
    'building': ['建筑', '轨道', '铁道', '桥梁', '结构力学', '房屋', '建材', '工程', '混凝土', '建设'],
    'chemical': ['化学', '传热学', '仪器', '药剂', '腐蚀', '制药', '化妆品', '酒', '香精', '聚合物', '水质', '药理'],
    'engineering': ['测量', '力学', '光谱', '检测', '有限单元'],
    'practice': ['实习', '实训', '营销', '就业', '实践', '职业'],
    'circuit': ['电工', '电磁', '电子', '信号', '数码', '数字', '嵌入式', 'EDA', '单片机'],
    'computer': [
      'Python',
      '计算机',
      '程序设计',
      '软件',
      'web',
      '开发',
      '建模',
      '非线性编辑',
      '微机',
      '图形',
      '操作系统',
      '数据结构',
      'C语言',
      '编译',
      '人工智能'
    ],
    'control': ['控制', '半导体', '泵', '电源', '系统', '故障诊断', '接触网', '维修', '液压', '气压', '汽轮机'],
    'experiment': ['特效', '会展', '实验', '活性剂', '光学'],
    'electricity': ['化工', '给水', '燃烧', '管网', '热工', '玻璃', '固废', '发电厂'],
    'music': ['音频', '音乐', '产品设计'],
    'social': ['园林'],
    'geography': ['生态', '一带一路', '大气污染', '地理'],
    'economic': ['估价', '贸易', '会计', '经济', '货币'],
    'physical': ['土壤', '国际', '物理'],
    'design': ['规划', '园艺', '线造型', '制图', '设计', 'Design', 'CAD'],
    'mechanical': ['工艺', '设备', '装备', '机械', '机电', '金属', '钢'],
    'sports': ['篮球'],
    'internship': ['香原料', '美容', '品评', '社区', '心理', '采编', '招聘', '妇女'],
    'political': ['珠宝'],
    'running': ['体育'],
    'language': ['英语', '德语', '语言', '法语', '日语', '英文', '英汉', '专业外语'],
    'ideological': ['思想道德', '毛泽东', '法治', '近现代史', '马克思', '政策', '政治'],
    'reading': ['植物', '信息论'],
    'management': ['食品', '管理', '项目', '关系', '安全', '行为', '社会'],
    'training': ['通信', '网络', '物联网', '文献检索'],
    'business': ['多媒体', '动画', '审计', '企业'],
    'statistical': ['数据分析', '数据挖掘', '数据库', '大数据', '市场', '调研', '证券', '统计'],
    'mathematics': ['计算', '复变函数', '概率论', '积分', '数学', '代数'],
    'technology': ['空调', '技术', '科学', '科技'],
    'generality': ['书籍'],
    'literature': ['文学', '编辑', '新闻', '报刊'],
    'curriculum': ['论文'],
  };

  static const _fallbackCat = "principle";

  static String query(String curriculum, {String fallback = _fallbackCat}) {
    for (var title in _courseToCategory.keys) {
      for (var item in _courseToCategory[title]!) {
        if (curriculum.contains(item)) {
          return title;
        }
      }
    }
    return fallback;
  }

  static const String _courseIconDir = 'assets/course';

  static String iconPathOf({String? courseName, String? iconName}) {
    final String icon;
    if (iconName != null && _courseToCategory.containsKey(iconName)) {
      icon = iconName;
    } else if (courseName != null) {
      icon = query(courseName);
    } else {
      icon = _fallbackCat;
    }
    return "$_courseIconDir/$icon.png";
  }
}

final List<String> weekWord = ['一', '二', '三', '四', '五', '六', '日'];

class TimePoint {
  /// 小时
  final int hour;

  /// 分
  final int minute;

  const TimePoint(this.hour, this.minute);

  const TimePoint.fromMinutes(int minutes)
      : hour = minutes ~/ 60,
        minute = minutes % 60;

  @override
  String toString() => '$hour:${'$minute'.padLeft(2, '0')}';

  String toStringPrefixed0({bool hour = true, bool minute = true}) {
    final sb = StringBuffer();
    if (hour) {
      sb.write(this.hour.toString().padLeft(2, '0'));
    } else {
      sb.write(this.hour.toString());
    }
    sb.write(':');
    if (minute) {
      sb.write(this.minute.toString().padLeft(2, '0'));
    } else {
      sb.write(this.minute.toString());
    }
    return sb.toString();
  }

  TimeDuration difference(TimePoint b) => TimeDuration.fromMinutes(totalMinutes - b.totalMinutes);

  TimePoint operator -(TimeDuration b) => TimePoint.fromMinutes(totalMinutes - b.totalMinutes);

  TimePoint operator +(TimeDuration b) => TimePoint.fromMinutes(totalMinutes + b.totalMinutes);

  int get totalMinutes => hour * 60 + minute;
}

extension DateTimeTimePointX on DateTime {
  DateTime addTimePoint(TimePoint t) {
    return add(Duration(hours: t.hour, minutes: t.minute));
  }
}

class TimeDuration {
  final int hour;
  final int minute;
  static const _i18n = TimeI18n();

  int get totalMinutes => hour * 60 + minute;

  const TimeDuration(this.hour, this.minute);

  const TimeDuration.fromMinutes(int minutes)
      : hour = minutes ~/ 60,
        minute = minutes % 60;

  String localized() {
    final h = "$hour";
    final min = "$minute".padLeft(2, '0');
    if (hour == 0) {
      return _i18n.minuteFormat(min);
    } else if (minute == 0) {
      return _i18n.hourFormat(h);
    }
    return _i18n.hourMinuteFormat(h, min);
  }

  Duration toDuration() => Duration(hours: hour, minutes: minute);
}

typedef ClassTime = ({TimePoint begin, TimePoint end});

extension ClassTimeX on ClassTime {
  TimeDuration get duration {
    return end.difference(begin);
  }
}

const fengxianCampusCommonTimetable = <ClassTime>[
  // 上午
  (begin: TimePoint(8, 20), end: TimePoint(9, 05)),
  (begin: TimePoint(9, 10), end: TimePoint(9, 55)),
  (begin: TimePoint(10, 15), end: TimePoint(11, 00)),
  (begin: TimePoint(11, 05), end: TimePoint(11, 50)),
  // 下午
  (begin: TimePoint(13, 00), end: TimePoint(13, 45)),
  (begin: TimePoint(13, 50), end: TimePoint(14, 35)),
  (begin: TimePoint(14, 55), end: TimePoint(15, 40)),
  (begin: TimePoint(15, 45), end: TimePoint(16, 30)),
  // 晚上
  (begin: TimePoint(18, 00), end: TimePoint(18, 45)),
  (begin: TimePoint(18, 50), end: TimePoint(19, 35)),
  (begin: TimePoint(19, 40), end: TimePoint(20, 25)),
];

const fengxianTeachingBuilding1Timetable = <ClassTime>[
  // 上午
  (begin: TimePoint(8, 20), end: TimePoint(9, 05)),
  (begin: TimePoint(9, 10), end: TimePoint(9, 55)),
  (begin: TimePoint(10, 25), end: TimePoint(11, 10)),
  (begin: TimePoint(11, 15), end: TimePoint(12, 00)),
  // 下午
  (begin: TimePoint(13, 00), end: TimePoint(13, 45)),
  (begin: TimePoint(13, 50), end: TimePoint(14, 35)),
  (begin: TimePoint(14, 55), end: TimePoint(15, 40)),
  (begin: TimePoint(15, 45), end: TimePoint(16, 30)),
  // 晚上
  (begin: TimePoint(18, 00), end: TimePoint(18, 45)),
  (begin: TimePoint(18, 50), end: TimePoint(19, 35)),
  (begin: TimePoint(19, 40), end: TimePoint(20, 25)),
];

const fengxianTeachingBuilding2Timetable = <ClassTime>[
  // 上午 （3-4不下课）
  (begin: TimePoint(8, 20), end: TimePoint(9, 05)),
  (begin: TimePoint(9, 10), end: TimePoint(9, 55)),
  (begin: TimePoint(10, 15), end: TimePoint(11, 00)),
  (begin: TimePoint(11, 05), end: TimePoint(11, 50)),
  // 下午
  (begin: TimePoint(13, 00), end: TimePoint(13, 45)),
  (begin: TimePoint(13, 50), end: TimePoint(14, 35)),
  (begin: TimePoint(14, 55), end: TimePoint(15, 40)),
  (begin: TimePoint(15, 45), end: TimePoint(16, 30)),
  // 晚上
  (begin: TimePoint(18, 00), end: TimePoint(18, 45)),
  (begin: TimePoint(18, 50), end: TimePoint(19, 35)),
  (begin: TimePoint(19, 40), end: TimePoint(20, 25)),
];

const fengxianTeachingBuilding3Timetable = <ClassTime>[
  // 上午 （3-4不下课）
  (begin: TimePoint(8, 20), end: TimePoint(9, 05)),
  (begin: TimePoint(9, 10), end: TimePoint(9, 55)),
  (begin: TimePoint(10, 15), end: TimePoint(11, 00)),
  (begin: TimePoint(11, 05), end: TimePoint(11, 50)),
  // 下午
  (begin: TimePoint(13, 00), end: TimePoint(13, 45)),
  (begin: TimePoint(13, 50), end: TimePoint(14, 35)),
  (begin: TimePoint(14, 55), end: TimePoint(15, 40)),
  (begin: TimePoint(15, 45), end: TimePoint(16, 30)),
  // 晚上
  (begin: TimePoint(18, 00), end: TimePoint(18, 45)),
  (begin: TimePoint(18, 50), end: TimePoint(19, 35)),
  (begin: TimePoint(19, 40), end: TimePoint(20, 25)),
];

const xuhuiCampusCommonTimetable = <ClassTime>[
  // 上午
  (begin: TimePoint(8, 00), end: TimePoint(8, 45)),
  (begin: TimePoint(8, 50), end: TimePoint(9, 35)),
  (begin: TimePoint(9, 55), end: TimePoint(10, 40)),
  (begin: TimePoint(10, 45), end: TimePoint(11, 30)),
  // 下午
  (begin: TimePoint(13, 00), end: TimePoint(13, 45)),
  (begin: TimePoint(13, 50), end: TimePoint(14, 35)),
  (begin: TimePoint(14, 55), end: TimePoint(15, 40)),
  (begin: TimePoint(15, 45), end: TimePoint(16, 30)),
  // 晚上
  (begin: TimePoint(18, 00), end: TimePoint(18, 45)),
  (begin: TimePoint(18, 50), end: TimePoint(19, 35)),
  (begin: TimePoint(19, 40), end: TimePoint(20, 25)),
];

/// 解析 timeIndex, 得到第一节小课的序号. 如给出 1~4, 返回 1
int getIndexStart(int index) {
  int i = 0;
  while (index & 1 == 0) {
    i++;
    index >>= 1;
  }
  return i;
}

/// 解析 timeIndex, 得到最后一节小课的序号. 如给出 1~4, 返回 4
int getIndexEnd(int start, int index) {
  int i = start;
  index >>= start + 1;
  while (index & 1 != 0) {
    i++;
    index >>= 1;
  }
  return i;
}

List<ClassTime> getTeachingBuildingTimetable(String campus, String place) {
  if (campus.contains('徐汇')) {
    return xuhuiCampusCommonTimetable;
  }
  if (place.startsWith('一教')) {
    return fengxianTeachingBuilding1Timetable;
  } else if (place.startsWith('二教')) {
    return fengxianTeachingBuilding2Timetable;
  } else if (place.startsWith("三教")) {
    return fengxianTeachingBuilding3Timetable;
  }
  return fengxianCampusCommonTimetable;
}

/// 将 "第几周、周几" 转换为日期. 如, 开学日期为 2021-9-1, 那么将第一周周一转换为 2021-9-1
DateTime reflectWeekDayIndexToDate({
  required DateTime startDate,
  required int weekIndex,
  required int dayIndex,
}) {
  return startDate.add(Duration(days: weekIndex * 7 + dayIndex));
}

/// 删去 place 括号里的描述信息. 如, 二教F301（机电18中外合作专用）
String beautifyPlace(String place) {
  int indexOfBucket = place.indexOf('(');
  return indexOfBucket != -1 ? place.substring(0, indexOfBucket) : place;
}

/// Replace the full-width brackets to ASCII ones
String mapChinesePunctuations(String name) {
  // TODO: improve performance
  return name.replaceAll("（", "(").replaceAll("）", ")").replaceAll("【", "[").replaceAll("】", "]").replaceAll("＆", "&");
}
