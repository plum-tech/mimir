import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/school/entity/school.dart';

import '../using.dart';

part 'exam.g.dart';

String _parseCourseName(dynamic courseName) {
  return mapChinesePunctuations(courseName.toString());
}

@JsonSerializable()
@HiveType(typeId: HiveTypeId.examEntry)
class ExamEntry {
  /// 课程名称
  @JsonKey(name: 'kcmc', fromJson: _parseCourseName)
  @HiveField(0)
  final String courseName;

  /// 考试时间. 若无数据, 列表未空.
  @JsonKey(name: 'kssj', fromJson: _stringToList)
  @HiveField(1)
  final List<DateTime> time;

  /// 考试地点
  @JsonKey(name: 'cdmc')
  @HiveField(2)
  final String place;

  /// 考试校区
  @JsonKey(name: 'cdxqmc')
  @HiveField(3)
  final String campus;

  /// 考试座号
  @JsonKey(name: 'zwh', fromJson: _stringToInt)
  @HiveField(4)
  final int seatNumber;

  /// 是否重修
  @JsonKey(name: 'cxbj', defaultValue: '未知')
  @HiveField(5)
  final String referralStatus;

  const ExamEntry({
    required this.courseName,
    required this.place,
    required this.campus,
    required this.time,
    required this.seatNumber,
    required this.referralStatus,
  });

  factory ExamEntry.fromJson(Map<String, dynamic> json) => _$ExamEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ExamEntryToJson(this);

  @override
  String toString() {
    return 'ExamEntry{courseName: $courseName, time: $time, place: $place, campus: $campus, seatNumber: $seatNumber, isSecondExam: $referralStatus}';
  }

  static int _stringToInt(String s) => int.tryParse(s) ?? 0;

  static List<DateTime> _stringToList(String s) {
    List<DateTime> result = [];
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm');

    try {
      final date = s.split('(')[0];
      final time = s.split('(')[1].replaceAll(')', '');
      String start = '$date ${time.split('-')[0]}';
      String end = '$date ${time.split('-')[1]}';

      final startTime = dateFormat.parse(start);
      final endTime = dateFormat.parse(end);

      result.add(startTime);
      result.add(endTime);
    } catch (_) {}

    return result;
  }

  static int comparator(ExamEntry a, ExamEntry b) {
    if (a.time.isEmpty || b.time.isEmpty) {
      if (a.time.isEmpty != b.time.isEmpty) {
        return a.time.isEmpty ? 1 : -1;
      }
      return 0;
    }
    return a.time[0].isAfter(b.time[0]) ? 1 : -1;
  }
}
