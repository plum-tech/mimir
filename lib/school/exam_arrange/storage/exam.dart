import 'package:hive/hive.dart';
import 'package:mimir/school/entity/school.dart';

import '../entity/exam.dart';

class _K {
  static String examList(SchoolYear schoolYear, Semester semester) => "/examList/$schoolYear/$semester";
}

class ExamArrangeStorage {
  final Box<dynamic> box;

  const ExamArrangeStorage(this.box);

  List<ExamEntry>? getExamList({
    required SchoolYear year,
    required Semester semester,
  }) =>
      (box.get(_K.examList(year, semester)) as List?)?.cast<ExamEntry>();

  void setExamList(
    List<ExamEntry>? exams, {
    required SchoolYear year,
    required Semester semester,
  }) =>
      box.put(_K.examList(year, semester), exams);
}
