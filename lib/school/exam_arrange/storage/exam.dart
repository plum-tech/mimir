import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';
import 'package:mimir/school/entity/school.dart';

import '../entity/exam.dart';

class ExamStorageBox with CachedBox {
  static const _examArrangementNs = "/exam_arrange";
  @override
  final Box box;
  late final exams = listNamespace2<ExamEntry, SchoolYear, Semester>(_examArrangementNs, makeExamsKey);

  static String makeExamsKey(SchoolYear schoolYear, Semester semester) => "$schoolYear/$semester";

  ExamStorageBox(this.box);
}

class ExamStorage {
  final ExamStorageBox box;

  ExamStorage(Box<dynamic> hive) : box = ExamStorageBox(hive);

  List<ExamEntry>? getExamList({
    required SchoolYear year,
    required Semester semester,
  }) {
    final cacheKey = box.exams.make(year, semester);
    return cacheKey.value;
  }

  void setExamList(
    List<ExamEntry>? exams, {
    required SchoolYear year,
    required Semester semester,
  }) {
    final cacheKey = box.exams.make(year, semester);
    cacheKey.value = exams;
  }
}
