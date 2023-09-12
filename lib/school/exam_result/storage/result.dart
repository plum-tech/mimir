import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';
import 'package:mimir/school/entity/school.dart';

import '../entity/result.dart';

class _Key {
  static const ns = "/examResult";
  static const results = "$ns/results";
}

class ExamResultStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final results = listNamespace2<ExamResult, SchoolYear, Semester>(_Key.results, makeResultKey);

  String makeResultKey(SchoolYear schoolYear, Semester semester) => "$schoolYear/$semester";

  String makeResultDetailKey(String classId, SchoolYear schoolYear, Semester semester) =>
      "$classId/$schoolYear/$semester";

  ExamResultStorageBox(this.box);
}

class ExamResultStorage {
  final ExamResultStorageBox box;

  ExamResultStorage(Box<dynamic> hive) : box = ExamResultStorageBox(hive);

  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.results.make(schoolYear, semester);
    return cacheKey.value;
  }

  void setResultList(SchoolYear schoolYear, Semester semester, List<ExamResult>? results) {
    final cacheKey = box.results.make(schoolYear, semester);
    cacheKey.value = results;
  }
}
