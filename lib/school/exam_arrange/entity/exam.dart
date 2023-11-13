import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/hive/type_id.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/entity/school.dart';

part 'exam.g.dart';

String _parseCourseName(dynamic courseName) {
  return mapChinesePunctuations(courseName.toString());
}

String _parsePlace(dynamic place) {
  return mapChinesePunctuations(place.toString());
}

int? _parseSeatNumber(String s) => int.tryParse(s);
final _timeFormat = DateFormat('yyyy-MM-dd hh:mm');

List<DateTime> _parseTime(String s) {
  List<DateTime> result = [];

  try {
    final date = s.split('(')[0];
    final time = s.split('(')[1].replaceAll(')', '');
    String start = '$date ${time.split('-')[0]}';
    String end = '$date ${time.split('-')[1]}';

    final startTime = _timeFormat.parse(start);
    final endTime = _timeFormat.parse(end);

    result.add(startTime);
    result.add(endTime);
  } catch (_) {}

  return result;
}

bool? _parseRetake(dynamic status) {
  if (status == null) return null;
  return switch (status.toString()) {
    "是" => true,
    "否" => false,
    _ => null,
  };
}

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeExam.entry)
class ExamEntry {
  /// 课程名称
  @JsonKey(name: 'kcmc', fromJson: _parseCourseName)
  @HiveField(0)
  final String courseName;

  /// 考试时间. 若无数据, 列表未空.
  @JsonKey(name: 'kssj', fromJson: _parseTime)
  @HiveField(1)
  // TODO: Use record
  final List<DateTime> _timeRaw;

  /// 考试地点
  @JsonKey(name: 'cdmc', fromJson: _parsePlace)
  @HiveField(2)
  final String place;

  /// 考试校区
  @JsonKey(name: 'cdxqmc')
  @HiveField(3)
  final String campus;

  /// 考试座号
  @JsonKey(name: 'zwh', fromJson: _parseSeatNumber)
  @HiveField(4)
  final int? seatNumber;

  /// 是否重修
  @JsonKey(name: 'cxbj', fromJson: _parseRetake)
  @HiveField(5)
  final bool? isRetake;

  ({DateTime start, DateTime end})? get time {
    if (_timeRaw.length == 2) {
      return (start: _timeRaw.first, end: _timeRaw.last);
    }
    return null;
  }

  ExamEntry({
    required this.courseName,
    required this.place,
    required this.campus,
    ({DateTime start, DateTime end})? time,
    required this.seatNumber,
    required this.isRetake,
  }) : _timeRaw = time == null ? [] : [time.start, time.end];

  ExamEntry.legacy({
    required this.courseName,
    required this.place,
    required this.campus,
    required List<DateTime> time,
    required this.seatNumber,
    required this.isRetake,
  }) : _timeRaw = time;

  factory ExamEntry.fromJson(Map<String, dynamic> json) => _$ExamEntryFromJson(json);

  @override
  String toString() {
    return {
      "courseName": courseName,
      "time": time,
      "place": place,
      "campus": campus,
      "seatNumber": seatNumber,
      "isRetake": isRetake,
    }.toString();
  }

  static int comparator(ExamEntry a, ExamEntry b) {
    final timeA = a.time;
    final timeB = b.time;
    if (timeA == null || timeB == null) {
      if (timeA != timeB) {
        return timeA == null ? 1 : -1;
      }
      return 0;
    }
    return timeA.start.isAfter(timeB.start) ? 1 : -1;
  }
}

extension ExamEntryX on ExamEntry {
  String buildDate(BuildContext context) {
    final time = this.time;
    assert(time != null);
    if (time == null) return "null";
    final (:start, :end) = time;
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      // at the same day
      return context.formatMdWeekText(start);
    } else {
      return "${context.formatMdNum(start)}–${context.formatMdNum(end)}";
    }
  }

  String buildTime(BuildContext context) {
    final time = this.time;
    assert(time != null);
    if (time == null) return "null";
    final (:start, :end) = time;
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      // at the same day
      return "${context.formatHmNum(start)}–${context.formatHmNum(end)}";
    } else {
      return "${context.formatMdhmNum(start)}–${context.formatMdhmNum(end)}";
    }
  }
}
