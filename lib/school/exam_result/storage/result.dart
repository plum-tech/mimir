import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/hive/init.dart';
import 'package:sit/school/entity/school.dart';

import '../entity/result.dart';

class _K {
  static String resultList(SchoolYear schoolYear, Semester semester) => "/resultList/$schoolYear/$semester";
}

class ExamResultStorage {
  Box get box => HiveInit.examResult;

  const ExamResultStorage();

  List<ExamResult>? getResultList(SemesterInfo info) =>
      (box.get(_K.resultList(info.year, info.semester)) as List?)?.cast<ExamResult>();

  void setResultList(SemesterInfo info, List<ExamResult>? results) =>
      box.put(_K.resultList(info.year, info.semester), results);

  ValueListenable<Box> listenResultList(SemesterInfo info) =>
      box.listenable(keys: [_K.resultList(info.year, info.semester)]);
}
