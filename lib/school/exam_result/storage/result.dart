import 'package:hive/hive.dart';
import 'package:mimir/school/entity/school.dart';

import '../entity/result.dart';

class _K {
  static String resultList(SchoolYear schoolYear, Semester semester) => "/resultList/$schoolYear/$semester";
}

class ExamResultStorage {
  final Box<dynamic> box;

  const ExamResultStorage(this.box);

  List<ExamResult>? getResultList({
    required SchoolYear year,
    required Semester semester,
  }) =>
      (box.get(_K.resultList(year, semester)) as List?)?.cast<ExamResult>();

  void setResultList(
    List<ExamResult>? results, {
    required SchoolYear year,
    required Semester semester,
  }) =>
      box.put(_K.resultList(year, semester), results);
}
