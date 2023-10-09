import 'package:hive/hive.dart';
import 'package:sit/school/entity/school.dart';

import '../entity/exam.dart';

class _K {
  static String examList(SchoolYear schoolYear, Semester semester) => "/examList/$schoolYear/$semester";
}

class ExamArrangeStorage {
  final Box box;

  const ExamArrangeStorage(this.box);

  List<ExamEntry>? getExamList(SemesterInfo info) =>
      (box.get(_K.examList(info.year, info.semester)) as List?)?.cast<ExamEntry>();

  void setExamList(
    SemesterInfo info,
    List<ExamEntry>? exams,
  ) =>
      box.put(_K.examList(info.year, info.semester), exams);
}
