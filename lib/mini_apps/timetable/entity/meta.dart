import 'package:json_annotation/json_annotation.dart';

import '../using.dart';

part 'meta.g.dart';

/// 存放课表元数据
@JsonSerializable()
class TimetableMetaLegacy extends HiveObject {
  /// 课表名称
  @JsonKey()
  String name = '';

  /// 课表描述
  @JsonKey()
  String description = '';

  /// 课表的起始时间
  @JsonKey()
  DateTime startDate = DateTime.now();

  /// 学年
  @JsonKey()
  int schoolYear = 0;

  /// 学期
  @JsonKey()
  int semester = 0;

  @override
  String toString() {
    return 'TimetableMeta{name: $name, description: $description, startDate: $startDate, schoolYear: $schoolYear, semester: $semester}';
  }
}
