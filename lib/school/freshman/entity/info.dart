import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/entity/campus.dart';

part 'info.g.dart';

@JsonSerializable()
class FreshmanInfo {
  /// 学号
  final String studentId;

  /// 身份证号
  final String idNumber;

  /// 姓名
  final String name;

  /// 性别
  final String sex;

  /// 录取院系
  final String college;

  /// 录取专业
  final String major;

  /// 班级
  final String yearClass;

  /// 园区
  final Campus campus;

  /// 楼宇
  final String buildingNumber;

  /// 房间
  final String roomNumber;

  /// 床位
  final String bedNumber;

  /// 辅导员姓名
  final String counselorName;

  /// 辅导员联系方式
  final String counselorContact;

  /// 辅导员补充说明
  final String counselorNote;

  const FreshmanInfo({
    required this.studentId,
    required this.idNumber,
    required this.name,
    required this.sex,
    required this.college,
    required this.major,
    required this.yearClass,
    required this.campus,
    required this.buildingNumber,
    required this.roomNumber,
    required this.bedNumber,
    required this.counselorName,
    required this.counselorContact,
    required this.counselorNote,
  });

  factory FreshmanInfo.fromJson(Map<String, dynamic> json) => _$FreshmanInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FreshmanInfoToJson(this);
}
