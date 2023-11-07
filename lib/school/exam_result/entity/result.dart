import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/hive/type_id.dart';
import 'package:sit/school/entity/school.dart';

part 'result.g.dart';

String _parseCourseName(dynamic courseName) {
  return mapChinesePunctuations(courseName.toString());
}

final _timeFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

DateTime? _parseTime(dynamic time) {
  if (time == null) return null;
  return _timeFormat.parse(time.toString());
}

@JsonSerializable()
@HiveType(typeId: HiveTypeExam.result)
class ExamResult {
  /// If the teacher of class hasn't been evaluated, the score is NaN.
  @JsonKey(name: 'cj', fromJson: stringToDouble)
  @HiveField(0)
  final double score;

  /// 课程
  @JsonKey(name: 'kcmc', fromJson: _parseCourseName)
  @HiveField(1)
  final String courseName;

  /// 课程代码
  @JsonKey(name: 'kch')
  @HiveField(2)
  final String courseId;

  /// 班级（正方内部使用）
  @JsonKey(name: 'jxb_id')
  @HiveField(3)
  final String innerClassId;

  /// 班级ID（数字）
  @JsonKey(name: 'jxbmc', defaultValue: "")
  @HiveField(4)
  final String dynClassId;

  /// 学年
  @JsonKey(name: 'xnmmc', fromJson: formFieldToSchoolYear, toJson: schoolYearToFormField)
  @HiveField(5)
  final SchoolYear year;

  /// 学期
  @JsonKey(name: 'xqm', fromJson: formFieldToSemester)
  @HiveField(6)
  final Semester semester;

  /// 学分
  @JsonKey(name: 'xf', fromJson: stringToDouble)
  @HiveField(7)
  final double credit;

  @JsonKey(name: "tjsj", fromJson: _parseTime, includeToJson: false)
  @HiveField(8)
  final DateTime? time;

  @JsonKey(includeToJson: false, includeFromJson: false)
  @HiveField(9)
  final List<ExamResultItem> items;

  const ExamResult({
    required this.score,
    required this.courseName,
    required this.courseId,
    required this.innerClassId,
    required this.year,
    required this.semester,
    required this.credit,
    required this.dynClassId,
    this.items = const [],
    required this.time,
  });

  ExamResult copyWith({
    double? score,
    String? courseName,
    String? courseId,
    String? innerClassId,
    SchoolYear? schoolYear,
    Semester? semester,
    String? dynClassId,
    double? credit,
    DateTime? time,
    List<ExamResultItem>? items,
  }) {
    return ExamResult(
      score: score ?? this.score,
      courseName: courseName ?? this.courseName,
      courseId: courseId ?? this.courseId,
      innerClassId: innerClassId ?? this.innerClassId,
      year: schoolYear ?? this.year,
      semester: semester ?? this.semester,
      credit: credit ?? this.credit,
      dynClassId: dynClassId ?? this.dynClassId,
      items: items ?? this.items,
      time: time ?? this.time,
    );
  }

  bool get hasScore => !score.isNaN;

  bool get passed => hasScore ? score >= 60.0 : false;

  factory ExamResult.fromJson(Map<String, dynamic> json) => _$ExamResultFromJson(json);

  @override
  String toString() {
    return {
      "score": "$score",
      "courseName": courseName,
      "courseId": courseId,
      "innerClassId": innerClassId,
      "dynClassId": dynClassId,
      "schoolYear": "$year",
      "semester": "$semester",
      "credit": "$credit",
      "time": time,
      "items": "$items",
    }.toString();
  }

  static int compareByTime(ExamResult a, ExamResult b) {
    final timeA = a.time;
    final timeB = b.time;
    if (timeA == null && timeB == null) return 0;
    if (timeA == null) return -1;
    if (timeB == null) return 1;
    return timeA.compareTo(timeB);
  }
}

@HiveType(typeId: HiveTypeExam.resultItem)
class ExamResultItem {
  /// 成绩名称
  @HiveField(0)
  final String scoreType;

  /// 占总成绩百分比
  @HiveField(1)
  final String percentage;

  /// 成绩数值
  @HiveField(3)
  final double score;

  const ExamResultItem(
    this.scoreType,
    this.percentage,
    this.score,
  );

  @override
  String toString() {
    return {
      "scoreType": scoreType,
      "percentage": percentage,
      "score": score,
    }.toString();
  }
}
