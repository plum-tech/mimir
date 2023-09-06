import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

import '../using.dart';

part 'result.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeId.examResult)
class ExamResult {
  /// 成绩
  @JsonKey(name: 'cj', fromJson: stringToDouble)
  @HiveField(0)
  final double value;

  /// 课程
  @JsonKey(name: 'kcmc')
  @HiveField(1)
  final String course;

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

  const ExamResult(this.value, this.course, this.courseId, this.innerClassId, this.schoolYear, this.semester,
      this.credit, this.dynClassId);

  factory ExamResult.fromJson(Map<String, dynamic> json) => _$ExamResultFromJson(json);

  @override
  String toString() {
    return 'Score{value: $value, course: $course, courseId: $courseId, innerClassId: $innerClassId, dynClassId: $dynClassId, schoolYear: $schoolYear, semester: $semester, credit: $credit}';
  }
}

@HiveType(typeId: HiveTypeId.examResultDetail)
class ExamResultDetail {
  /// 成绩名称
  @HiveField(0)
  final String scoreType;

  /// 占总成绩百分比
  @HiveField(1)
  final String percentage;

  /// 成绩数值
  @HiveField(3)
  final double value;

  const ExamResultDetail(
    this.scoreType,
    this.percentage,
    this.value,
  );
}
