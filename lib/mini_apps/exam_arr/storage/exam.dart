import 'package:hive/hive.dart';
import 'package:mimir/school/entity/school.dart';

import '../dao/exam.dart';
import '../entity/exam.dart';
import '../using.dart';

class ExamStorageBox with CachedBox {
  static const _examArrangementNs = "/exam_arr";
  @override
  final Box box;
  late final exams = ListNamespace2<ExamEntry, SchoolYear, Semester>(_examArrangementNs, makeExamsKey);

  static String makeExamsKey(SchoolYear schoolYear, Semester semester) => "$schoolYear/$semester";

  ExamStorageBox(this.box);
}

class ExamStorage extends ExamDao {
  final ExamStorageBox box;

  ExamStorage(Box<dynamic> hive) : box = ExamStorageBox(hive);

  @override
  Future<List<ExamEntry>?> getExamList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.exams.make(schoolYear, semester);
    return cacheKey.value;
  }

  void setExamList(SchoolYear schoolYear, Semester semester, List<ExamEntry>? exams) {
    final cacheKey = box.exams.make(schoolYear, semester);
    cacheKey.value = exams;
  }
}
