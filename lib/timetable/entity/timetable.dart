import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/entity/timetable.dart';

import 'patch.dart';

part 'timetable.g.dart';

DateTime _kLastModified() => DateTime.now();

@JsonSerializable()
@CopyWith(skipFields: true)
class SitTimetable {
  @JsonKey()
  final String name;
  @JsonKey()
  final DateTime startDate;
  @JsonKey()
  final int schoolYear;
  @JsonKey()
  final Semester semester;
  @JsonKey()
  final int lastCourseKey;
  @JsonKey()
  final String signature;

  /// The index is the CourseKey.
  @JsonKey()
  final Map<String, SitCourse> courses;

  @JsonKey(defaultValue: _kLastModified)
  final DateTime lastModified;

  @JsonKey()
  final int version;

  /// Timetable patches will be processed in list order.
  @JsonKey()
  final List<TimetablePatch> patches;

  const SitTimetable({
    required this.courses,
    required this.lastCourseKey,
    required this.name,
    required this.startDate,
    required this.schoolYear,
    required this.semester,
    required this.lastModified,
    this.patches = const [],
    this.signature = "",
    this.version = 1,
  });

  @override
  String toString() {
    return {
      "name": name,
      "startDate": startDate,
      "schoolYear": schoolYear,
      "semester": semester,
      "lastModified": lastModified,
      "signature": signature,
    }.toString();
  }

  String toDartCode() {
    return "SitTimetable("
        'name:"$name",'
        'signature:"$signature",'
        'startDate:DateTime.parse("$startDate"),'
        'lastModified:DateTime.now(),'
        "courses:${courses.map((key, value) => MapEntry('"$key"', value.toDartCode()))},"
        "schoolYear:$schoolYear,"
        "semester:$semester,"
        "lastCourseKey:$lastCourseKey,"
        "version:$version,"
        ")";
  }

  factory SitTimetable.fromJson(Map<String, dynamic> json) => _$SitTimetableFromJson(json);

  Map<String, dynamic> toJson() => _$SitTimetableToJson(this);
}

@JsonSerializable()
@CopyWith(skipFields: true)
class SitCourse {
  @JsonKey()
  final int courseKey;
  @JsonKey()
  final String courseName;
  @JsonKey()
  final String courseCode;
  @JsonKey()
  final String classCode;
  @JsonKey(unknownEnumValue: Campus.fengxian)
  final Campus campus;
  @JsonKey()
  final String place;

  @JsonKey()
  final TimetableWeekIndices weekIndices;

  /// e.g.: (start:1, end: 3) means `2nd slot to 4th slot`.
  /// Starts with 0
  @JsonKey()
  final ({int start, int end}) timeslots;
  @JsonKey()
  final double courseCredit;

  /// e.g.: `0` means `Monday`
  /// Starts with 0
  @JsonKey()
  final int dayIndex;
  @JsonKey()
  final List<String> teachers;

  @JsonKey()
  final bool hidden;

  const SitCourse({
    required this.courseKey,
    required this.courseName,
    required this.courseCode,
    required this.classCode,
    required this.campus,
    required this.place,
    required this.weekIndices,
    required this.timeslots,
    required this.courseCredit,
    required this.dayIndex,
    required this.teachers,
    this.hidden = false,
  });

  @override
  String toString() => "[$courseKey] $courseName";

  factory SitCourse.fromJson(Map<String, dynamic> json) => _$SitCourseFromJson(json);

  Map<String, dynamic> toJson() => _$SitCourseToJson(this);

  String toDartCode() {
    return "SitCourse("
        "courseKey:$courseKey,"
        'courseName:"$courseName",'
        'courseCode:"$courseCode",'
        'classCode:"$classCode",'
        "campus:$campus,"
        'place:"$place",'
        "weekIndices:${weekIndices.toDartCode()},"
        "timeslots:$timeslots,"
        "courseCredit:$courseCredit,"
        "dayIndex:$dayIndex,"
        "teachers:${teachers.map((t) => '"$t"').toList(growable: false)},"
        "hidden:$hidden,"
        ")";
  }
}

extension SitCourseEx on SitCourse {
  List<ClassTime> get buildingTimetable => getTeachingBuildingTimetable(campus, place);

  /// Based on [SitCourse.timeslots], compose a full-length class time.
  /// Starts with the first part starts.
  /// Ends with the last part ends.
  ClassTime calcBeginEndTimePoint() {
    final timetable = buildingTimetable;
    final (:start, :end) = timeslots;
    return (begin: timetable[start].begin, end: timetable[end].end);
  }

  List<ClassTime> calcBeginEndTimePointForEachLesson() {
    final timetable = buildingTimetable;
    final (:start, :end) = timeslots;
    final result = <ClassTime>[];
    for (var timeslot = start; timeslot <= end; timeslot++) {
      result.add(timetable[timeslot]);
    }
    return result;
  }

  ClassTime calcBeginEndTimePointOfLesson(int timeslot) {
    final timetable = buildingTimetable;
    return timetable[timeslot];
  }
}

@JsonEnum()
enum TimetableWeekIndexType {
  all,
  odd,
  even;

  String l10nOf(String start, String end) => "timetable.weekIndexType.of.$name".tr(namedArgs: {
        "start": start,
        "end": end,
      });

  String l10n() => "timetable.weekIndexType.$name".tr();

  static String l10nOfSingle(String index) => "timetable.weekIndexType.of.single".tr(args: [index]);
}

@JsonSerializable()
@CopyWith(skipFields: true)
class TimetableWeekIndex {
  @JsonKey()
  final TimetableWeekIndexType type;

  /// Both [start] and [end] are inclusive.
  /// [start] will equal to [end] if it's not ranged.
  @JsonKey()
  final ({int start, int end}) range;

  const TimetableWeekIndex({
    required this.type,
    required this.range,
  });

  const TimetableWeekIndex.all(
    this.range,
  ) : type = TimetableWeekIndexType.all;

  /// [start] will equal to [end].
  const TimetableWeekIndex.single(
    int weekIndex,
  )   : type = TimetableWeekIndexType.all,
        range = (start: weekIndex, end: weekIndex);

  const TimetableWeekIndex.odd(
    this.range,
  ) : type = TimetableWeekIndexType.odd;

  const TimetableWeekIndex.even(
    this.range,
  ) : type = TimetableWeekIndexType.even;

  /// week number start by
  bool match(int weekIndex) {
    return range.start <= weekIndex && weekIndex <= range.end;
  }

  bool get isSingle => range.start == range.end;

  /// convert the index to number.
  /// e.g.: (start: 0, end: 8) => "1–9"
  String l10n() {
    if (isSingle) {
      return TimetableWeekIndexType.l10nOfSingle("${range.start + 1}");
    } else {
      return type.l10nOf("${range.start + 1}", "${range.end + 1}");
    }
  }

  String toDartCode() {
    return "TimetableWeekIndex("
        "type:$type,"
        "range:$range,"
        ")";
  }

  factory TimetableWeekIndex.fromJson(Map<String, dynamic> json) => _$TimetableWeekIndexFromJson(json);

  Map<String, dynamic> toJson() => _$TimetableWeekIndexToJson(this);
}

@JsonSerializable()
class TimetableWeekIndices {
  @JsonKey()
  final List<TimetableWeekIndex> indices;

  const TimetableWeekIndices(this.indices);

  bool match(int weekIndex) {
    for (final index in indices) {
      if (index.match(weekIndex)) return true;
    }
    return false;
  }

  /// Then the [indices] could be ["a1-5", "s14", "o8-10"]
  /// The return value should be:
  /// - `1-5 周, 14 周, 8-10 单周` in Chinese.
  /// - `1-5 wk, 14 wk, 8-10 odd wk`
  List<String> l10n() {
    return indices.map((index) => index.l10n()).toList();
  }

  /// The result, week index, which starts with 0.
  /// e.g.:
  /// ```dart
  /// TimetableWeekIndices([
  ///  TimetableWeekIndex.all(
  ///    (start: 0, end: 4),
  ///  ),
  ///  TimetableWeekIndex.single(
  ///    13,
  ///  ),
  ///  TimetableWeekIndex.odd(
  ///    (start: 7, end: 9),
  ///  ),
  /// ])
  /// ```
  /// return value is {0,1,2,3,4,13,7,9}.
  Set<int> getWeekIndices() {
    final res = <int>{};
    for (final TimetableWeekIndex(:type, :range) in indices) {
      switch (type) {
        case TimetableWeekIndexType.all:
          for (var i = range.start; i <= range.end; i++) {
            res.add(i);
          }
          break;
        case TimetableWeekIndexType.odd:
          for (var i = range.start; i <= range.end; i += 2) {
            if ((i + 1).isOdd) res.add(i);
          }
          break;
        case TimetableWeekIndexType.even:
          for (var i = range.start; i <= range.end; i++) {
            if ((i + 1).isEven) res.add(i);
          }
          break;
      }
    }
    return res;
  }

  factory TimetableWeekIndices.fromJson(Map<String, dynamic> json) => _$TimetableWeekIndicesFromJson(json);

  Map<String, dynamic> toJson() => _$TimetableWeekIndicesToJson(this);

  String toDartCode() {
    return "TimetableWeekIndices("
        "${indices.map((i) => i.toDartCode()).toList(growable: false)}"
        ")";
  }
}

/// If [range] is "1-8", the output will be `(start:0, end: 7)`.
/// if [number2index] is true, the [range] will be considered as a number range, which starts with 1 instead of 0.
({int start, int end}) rangeFromString(
  String range, {
  bool number2index = false,
}) {
  if (range.contains("-")) {
// in range of time slots
    final rangeParts = range.split("-");
    final start = int.parse(rangeParts[0]);
    final end = int.parse(rangeParts[1]);
    if (number2index) {
      return (start: start - 1, end: end - 1);
    } else {
      return (start: start, end: end);
    }
  } else {
    final single = int.parse(range);
    if (number2index) {
      return (start: single - 1, end: single - 1);
    } else {
      return (start: single, end: single);
    }
  }
}

String rangeToString(({int start, int end}) range) {
  if (range.start == range.end) {
    return "${range.start}";
  } else {
    return "${range.start}-${range.end}";
  }
}
