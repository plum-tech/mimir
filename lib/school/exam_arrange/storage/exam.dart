import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/utils/json.dart';

import '../entity/exam.dart';

class _K {
  static String examList(SchoolYear schoolYear, Semester semester) => "/examList/$schoolYear/$semester";
}

class ExamArrangeStorage {
  Box get box => HiveInit.examArrange;

  const ExamArrangeStorage();

  List<ExamEntry>? getExamList(SemesterInfo info) =>
      decodeJsonList(box.get(_K.examList(info.year, info.semester)), (e) => ExamEntry.fromJson(e));

  void setExamList(
    SemesterInfo info,
    List<ExamEntry>? exams,
  ) =>
      box.put(_K.examList(info.year, info.semester), encodeJsonList(exams, (e) => e.toJson()));
}
