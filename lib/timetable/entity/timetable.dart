import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/school/entity/school.dart';

import '../i18n.dart';
import '../utils.dart';
import 'course.dart';

part 'timetable.g.dart';

@JsonSerializable()
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
  final int courseKeyCounter;

  /// The index is the CourseKey.
  @JsonKey()
  final List<SitCourse> courseKey2Entity;

  const SitTimetable({
    required this.courseKey2Entity,
    required this.courseKeyCounter,
    required this.name,
    required this.startDate,
    required this.schoolYear,
    required this.semester,
  });

  factory SitTimetable.parse(List<CourseRaw> all) {
    return parseTimetable(all);
  }

  SitTimetableEntity resolve() {
    return resolveTimetableEntity(this);
  }

  SitTimetable copyWith({
    String? name,
    DateTime? startDate,
    int? schoolYear,
    Semester? semester,
    List<SitCourse>? courseKey2Entity,
    int? courseKeyCounter,
  }) {
    return SitTimetable(
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      schoolYear: schoolYear ?? this.schoolYear,
      semester: semester ?? this.semester,
      courseKey2Entity: courseKey2Entity ?? this.courseKey2Entity,
      courseKeyCounter: courseKeyCounter ?? this.courseKeyCounter,
    );
  }

  @override
  String toString() => "[$courseKeyCounter]";

  factory SitTimetable.fromJson(Map<String, dynamic> json) => _$SitTimetableFromJson(json);

  Map<String, dynamic> toJson() => _$SitTimetableToJson(this);
}

class SitTimetableEntity {
  final SitTimetable type;

  /// The Default number of weeks is 20.
  final List<SitTimetableWeek?> weeks;

  final Map<String, List<SitCourse>> _code2CoursesCache = {};

  SitTimetableEntity({
    required this.type,
    required this.weeks,
  });

  SitCourse getCourseByKey(int courseKey) {
    return type.courseKey2Entity[courseKey];
  }

  List<SitCourse> findAndCacheCoursesByCourseCode(String courseCode) {
    final found = _code2CoursesCache[courseCode];
    if (found != null) {
      return found;
    } else {
      final res = <SitCourse>[];
      for (final course in type.courseKey2Entity) {
        if (course.courseCode == courseCode) {
          res.add(course);
        }
      }
      _code2CoursesCache[courseCode] = res;
      return res;
    }
  }
}

class SitTimetableWeek {
  /// The 7 days in a week
  final List<SitTimetableDay> days;

  SitTimetableWeek(this.days);

  factory SitTimetableWeek.$7days() {
    return SitTimetableWeek(List.generate(7, (index) => SitTimetableDay.$11slots()));
  }

  @override
  String toString() => "$days";
}

/// Lessons in the same Timeslot.
typedef LessonsInSlot = List<SitTimetableLesson>;

class SitTimetableDay {
  /// The Default number of lesson in one day is 11. But the length of lessons can be more.
  /// When two lessons are overlapped, it can be 12+.
  /// A Timeslot contain one or more lesson.
  List<LessonsInSlot> timeslots2Lessons;

  SitTimetableDay(this.timeslots2Lessons);

  factory SitTimetableDay.$11slots() {
    return SitTimetableDay(List.generate(11, (index) => <SitTimetableLesson>[]));
  }

  void add(SitTimetableLesson lesson, {required int at}) {
    assert(0 <= at && at < timeslots2Lessons.length);
    if (0 <= at && at < timeslots2Lessons.length) {
      timeslots2Lessons[at].add(lesson);
    }
  }

  /// At all lessons [layer]
  Iterable<SitTimetableLesson> browseLessonsAt({required int layer}) sync* {
    for (final lessonsInTimeslot in timeslots2Lessons) {
      if (0 <= layer && layer < lessonsInTimeslot.length) {
        yield lessonsInTimeslot[layer];
      }
    }
  }

  /// At the unique lessons [layer].
  /// So, if the [SitTimetableLesson.duration] is more than 1, it will only yield the first lesson.
  Iterable<SitTimetableLesson> browseUniqueLessonsAt({required int layer}) sync* {
    for (int timeslot = 0; timeslot < timeslots2Lessons.length; timeslot++) {
      final lessons = timeslots2Lessons[timeslot];
      if (0 <= layer && layer < lessons.length) {
        final lesson = lessons[layer];
        yield lesson;
        timeslot = lesson.endIndex;
      }
    }
  }

  bool hasAnyLesson() {
    for (final lessonsInTimeslot in timeslots2Lessons) {
      if (lessonsInTimeslot.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() => "$timeslots2Lessons";
}

class SitTimetableLesson {
  /// The start index of this lesson in a [SitTimetableWeek]
  final int startIndex;

  /// The end index of this lesson in a [SitTimetableWeek]
  final int endIndex;

  /// A lesson may last two or more time slots.
  /// If current [SitTimetableLesson] is a part of the whole lesson, they all have the same [courseKey].
  /// If there's no lesson, the [courseKey] is null.
  final int courseKey;

  /// How many timeslots this lesson takes.
  /// It's at least 1 timeslot.
  int get duration => endIndex - startIndex + 1;

  SitTimetableLesson(this.startIndex, this.endIndex, this.courseKey);

  @override
  String toString() => "[$courseKey] $startIndex-$endIndex";
}

extension SitTimetableLessonEx on SitTimetableLesson {
  SitCourse getCourseIn(List<SitCourse> courseKey2Entity) {
    return courseKey2Entity[courseKey];
  }
}

@JsonSerializable()
class SitCourse {
  @JsonKey()
  final int courseKey;
  @JsonKey()
  final String courseName;
  @JsonKey()
  final String courseCode;
  @JsonKey()
  final String classCode;
  @JsonKey()
  final String campus;
  @JsonKey()
  final String place;

  /// The icon name in
  @JsonKey()
  final String iconName;

  @JsonKey(toJson: _weekIndicesToJson, fromJson: _weekIndicesFromJson)
  final TimetableWeekIndices weekIndices;

  /// e.g.: (start:1, end: 3) means `2nd slot to 4th slot`.
  /// Starts with 0
  @JsonKey(toJson: rangeToString, fromJson: rangeFromString)
  final ({int start, int end}) timeslots;
  @JsonKey()
  final double courseCredit;
  @JsonKey()
  final int creditHour;

  /// e.g.: `0` means `Monday`
  /// Starts with 0
  @JsonKey()
  final int dayIndex;
  @JsonKey()
  final List<String> teachers;

  const SitCourse({
    required this.courseKey,
    required this.courseName,
    required this.courseCode,
    required this.classCode,
    required this.campus,
    required this.place,
    required this.iconName,
    required this.weekIndices,
    required this.timeslots,
    required this.courseCredit,
    required this.creditHour,
    required this.dayIndex,
    required this.teachers,
  });

  @override
  String toString() => "[$courseKey] $courseName";

  factory SitCourse.fromJson(Map<String, dynamic> json) => _$SitCourseFromJson(json);

  Map<String, dynamic> toJson() => _$SitCourseToJson(this);
}

extension SitCourseEx on SitCourse {
  String localizedWeekNumbers({String separateBy = ", "}) {
    return weekIndices.l10n().join(separateBy);
  }

  String localizedCampusName() {
    if (campus.contains("徐汇")) {
      return i18n.campus.xuhui;
    } else {
      return i18n.campus.fengxian;
    }
  }

  List<ClassTime> get buildingTimetable => getTeacherBuildingTimetable(campus, place);

  TimeDuration duration({required SitTimetableLesson basedOn}) {
    final timetable = buildingTimetable;
    final classBegin = timetable[basedOn.startIndex].begin;
    final classOver = timetable[basedOn.endIndex].end;
    return classOver.difference(classBegin);
  }

  /// Based on [SitCourse.timeslots], compose a full-length class time.
  /// Starts with the first part starts.
  /// Ends with the last part ends.
  ClassTime calcBeginEndTimepoint() {
    final timetable = buildingTimetable;
    final (:start, :end) = timeslots;
    return (begin: timetable[start].begin, end: timetable[end].end);
  }

  List<ClassTime> calcBeginEndTimepointForEachLesson() {
    final timetable = buildingTimetable;
    final (:start, :end) = timeslots;
    final result = <ClassTime>[];
    for (var timeslot = start; timeslot <= end; timeslot++) {
      result.add(timetable[timeslot]);
    }
    return result;
  }
}

const _kAll = "a";
const _kOdd = "o";
const _kEven = "e";

enum TimetableWeekIndexType {
  all(_kAll),
  odd(_kOdd),
  even(_kEven);

  final String indicator;

  const TimetableWeekIndexType(this.indicator);

  String l10n() => "timetable.weekStep.$name".tr();

  static TimetableWeekIndexType of(String indicator) {
    return switch (indicator) {
      _kOdd => TimetableWeekIndexType.odd,
      _kEven => TimetableWeekIndexType.even,
      _ => TimetableWeekIndexType.all,
    };
  }
}

class TimetableWeekIndex {
  final TimetableWeekIndexType type;

  /// Both [start] and [end] are inclusive.
  /// [start] will equal to [end] if it's not ranged.
  final ({int start, int end}) range;

  const TimetableWeekIndex({
    required this.type,
    required this.range,
  });

  /// week number start by
  bool match(int weekIndex) {
    return range.start <= weekIndex && weekIndex <= range.end;
  }

  /// convert the index to number.
  /// e.g.: (start: 0, end: 8) => "1-9"
  String l10n() {
    // TODO: better l10n
    return "${range.start + 1} ${type.l10n()}";
  }
}

class TimetableWeekIndices {
  final List<TimetableWeekIndex> indices;

  TimetableWeekIndices(this.indices);

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
    final res = <String>[];
    for (final index in indices) {
      res.add(index.l10n());
    }
    return res;
  }

  /// The result, week index, which starts with 0.
  /// e.g.:
  /// ```dart
  /// TimetableWeekIndices([
  ///  WeekIndexType(
  ///    type: WeekIndexType.all,
  ///    range: (start: 0, end: 4),
  ///  ),
  ///  WeekIndexType(
  ///    type: WeekIndexType.all,
  ///    range: (start: 13, end: 13),
  ///  ),
  ///  WeekIndexType(
  ///    type: WeekIndexType.odd,
  ///    range: (start: 7, end: 9),
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
}

List<String> _weekIndicesToJson(TimetableWeekIndices indices) {
  final res = <String>[];
  for (final TimetableWeekIndex(:type, :range) in indices.indices) {
    res.add("${type.indicator}${rangeToString(range)}");
  }
  return res;
}

TimetableWeekIndices _weekIndicesFromJson(List indices) {
  final res = <TimetableWeekIndex>[];
  for (final index in indices.cast<String>()) {
    final type = TimetableWeekIndexType.of(index[0]);
    final range = rangeFromString(index.substring(1));
    res.add(TimetableWeekIndex(type: type, range: range));
  }
  return TimetableWeekIndices(res);
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
