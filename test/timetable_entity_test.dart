import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mimir/backend/entity/user.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/files.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/entity/timetable_entity.dart';
import 'package:statistics/statistics.dart';
import 'package:uuid/uuid.dart';

void main() {
  final timetable = _get();
  final entity = timetable.resolve();
  group("Check foundation", () {
    test("equality", () {
      final duplicate = timetable.copyWith();
      assert(timetable == duplicate);
      assert(timetable.hashCode == duplicate.hashCode);
    });
    test("Associated courses", () {
      final day = entity.getDaySinceStart(9)!;
      print(day);
    });
  });
  group("Test get day", () {
    test("get day by days", () {
      final day4 = entity.getDaySinceStart(4)!;
      print(day4);
      assert(day4.hasAnyLesson());
      assert(day4.associatedCourses.map((c) => c.courseKey).toSet().equalsElements({1, 2, 5, 6}));
      final day9 = entity.getDaySinceStart(9)!;
      print(day9);
      assert(day9.isFree);
    });
    test("get week of one day", () {
      final labourDayWeek = entity.getWeekOn(DateTime(2024, 5, 1))!;
      final labourDay = labourDayWeek.days[2];
      assert(labourDay.hasAnyLesson());
      assert(labourDay.associatedCourses.length == 1);
      assert(labourDay.associatedCourses.first.courseKey == 4);
    });
    test("get day", () {
      final labourDay = entity.getDayOn(DateTime(2024, 5, 1))!;
      assert(labourDay.hasAnyLesson());
      assert(labourDay.associatedCourses.length == 1);
      assert(labourDay.associatedCourses.first.courseKey == 4);
    });
  });
}

Future<void> outputTestTimetableFile() async {
  final file = Directory.systemTemp.subFile("test.timetable");
  final timetable = _get();
  final json = jsonEncode(timetable.toJson());
  await file.writeAsString(json);
  print(file);
}

Timetable _get() {
  return Timetable(
    uuid: const Uuid().v4(),
    name: "Spring, 2023 Timetable",
    signature: "Liplum",
    studentId: "114514",
    schoolCode: SchoolCode.sit,
    studentType: StudentType.undergraduate,
    startDate: DateTime.parse("2024-02-26"),
    createdTime: DateTime.now(),
    lastModified: DateTime.now(),
    campus: Campus.fengxian,
    courses: const {
      "0": Course(
        courseKey: 0,
        courseName: "Java",
        courseCode: "001",
        classCode: "C1",
        place: "Oracle & Sun",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 4, start: 0),
          )
        ]),
        timeslots: (end: 3, start: 0),
        courseCredit: 0.0,
        dayIndex: 0,
        teachers: ["John"],
        hidden: false,
      ),
      "1": Course(
        courseKey: 1,
        courseName: "Kotlin",
        courseCode: "002",
        classCode: "C2",
        place: "Jetbrains",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 7, start: 0),
          )
        ]),
        timeslots: (end: 1, start: 0),
        courseCredit: 0.0,
        dayIndex: 3,
        teachers: ["Joe"],
        hidden: false,
      ),
      "2": Course(
        courseKey: 2,
        courseName: "Golang",
        courseCode: "003",
        classCode: "C3",
        place: "Google",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 7, start: 0),
          )
        ]),
        timeslots: (end: 3, start: 2),
        courseCredit: 1.0,
        dayIndex: 3,
        teachers: ["Denny"],
        hidden: false,
      ),
      "3": Course(
        courseKey: 3,
        courseName: "C#",
        courseCode: "004",
        classCode: "C4",
        place: "Microsoft",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 15, start: 8),
          )
        ]),
        timeslots: (end: 5, start: 4),
        courseCredit: 1.0,
        dayIndex: 0,
        teachers: ["Paul"],
        hidden: false,
      ),
      "4": Course(
        courseKey: 4,
        courseName: "Swift",
        courseCode: "005",
        classCode: "C5",
        place: "Apple",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 15, start: 8),
          )
        ]),
        timeslots: (end: 7, start: 4),
        courseCredit: 2.0,
        dayIndex: 2,
        teachers: ["Nick"],
        hidden: false,
      ),
      "5": Course(
        courseKey: 5,
        courseName: "Dart",
        courseCode: "006",
        classCode: "C6",
        place: "Google",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 15, start: 0),
          )
        ]),
        timeslots: (end: 5, start: 4),
        courseCredit: 2.0,
        dayIndex: 3,
        teachers: ["Ben"],
        hidden: false,
      ),
      "6": Course(
        courseKey: 6,
        courseName: "React",
        courseCode: "007",
        classCode: "C7",
        place: "Meta",
        weekIndices: TimetableWeekIndices([
          TimetableWeekIndex(
            type: TimetableWeekIndexType.all,
            range: (end: 7, start: 0),
          )
        ]),
        timeslots: (end: 7, start: 6),
        courseCredit: 1.0,
        dayIndex: 3,
        teachers: ["Tom"],
        hidden: false,
      )
    },
    schoolYear: 2023,
    semester: Semester.term2,
    lastCourseKey: 7,
    version: 1,
  );
}
