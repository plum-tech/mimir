import 'package:json_annotation/json_annotation.dart';

part 'evaluation.g.dart';

@JsonSerializable()
class CourseToEvaluate {
  /// 老师姓名
  @JsonKey(name: 'jzgmc')
  final String teacher;

  /// 正方内部 HASH 过的老师编号
  @JsonKey(name: 'jgh_id')
  final String teacherId;

  /// 课程代码
  @JsonKey(name: 'kch_id')
  final String courseId;

  /// 课程名称
  @JsonKey(name: 'kcmc')
  final String courseName;

  /// 班级号（课程班级）
  @JsonKey(name: 'jxbmc')
  final String dynClassId;

  /// 正方内部的一个 HASH 过后的班级号
  @JsonKey(name: 'jxb_id')
  final String innerClassId;

  /// 评教编号
  @JsonKey(name: 'pjmbmcb_id', defaultValue: '')
  final String evaluationId;

  /// 评教状态
  @JsonKey(name: 'pjzt')
  final String evaluatingStatus;

  /// 提交状态
  @JsonKey(name: 'tjzt')
  final String submittingStatus;

  /// 学时代码. 课程中的理论和实践部分分开评教.
  @JsonKey(name: 'xsdm')
  final String subTypeId;
  @JsonKey(name: 'xsmc')
  final String subType;

  const CourseToEvaluate(this.teacher, this.courseId, this.courseName, this.dynClassId, this.evaluationId,
      this.teacherId, this.innerClassId, this.evaluatingStatus, this.submittingStatus, this.subTypeId, this.subType);

  factory CourseToEvaluate.fromJson(Map<String, dynamic> json) => _$CourseToEvaluateFromJson(json);
}
