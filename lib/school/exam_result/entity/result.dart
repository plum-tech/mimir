import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/school/entity/school.dart';

part 'result.g.dart';

String _parseCourseName(dynamic courseName) {
  return mapChinesePunctuations(courseName.toString());
}

@JsonSerializable()
@HiveType(typeId: HiveTypeExam.examResult)
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
  @JsonKey(name: 'jxbmc', defaultValue: '无')
  @HiveField(4)
  final String dynClassId;

  /// 学年
  @JsonKey(name: 'xnmmc', fromJson: formFieldToSchoolYear, toJson: schoolYearToFormField)
  @HiveField(5)
  final SchoolYear schoolYear;

  /// 学期
  @JsonKey(name: 'xqm', fromJson: formFieldToSemester)
  @HiveField(6)
  final Semester semester;

  /// 学分
  @JsonKey(name: 'xf', fromJson: stringToDouble)
  @HiveField(7)
  final double credit;

  const ExamResult({
    required this.score,
    required this.courseName,
    required this.courseId,
    required this.innerClassId,
    required this.schoolYear,
    required this.semester,
    required this.credit,
    required this.dynClassId,
  });

  bool get hasScore => !score.isNaN;

  factory ExamResult.fromJson(Map<String, dynamic> json) => _$ExamResultFromJson(json);

  @override
  String toString() {
    return 'Score{value: $score, course: $courseName, courseId: $courseId, innerClassId: $innerClassId, dynClassId: $dynClassId, schoolYear: $schoolYear, semester: $semester, credit: $credit}';
  }
}

@HiveType(typeId: HiveTypeExam.examResultDetails)
class ExamResultDetails {
  /// 成绩名称
  @HiveField(0)
  final String scoreType;

  /// 占总成绩百分比
  @HiveField(1)
  final String percentage;

  /// 成绩数值
  @HiveField(3)
  final double value;

  const ExamResultDetails(
    this.scoreType,
    this.percentage,
    this.value,
  );
}
