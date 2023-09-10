import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';
import 'package:mimir/school/entity/school.dart';

import '../dao/result.dart';
import '../entity/result.dart';

class _Key {
  static const ns = "/examResult";
  static const resultDetails = "$ns/resultDetails";
  static const results = "$ns/results";
}

class ExamResultStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final results = listNamespace2<ExamResult, SchoolYear, Semester>(_Key.results, makeResultKey);
  late final resultDetails =
      listNamespace3<ExamResultDetail, String, SchoolYear, Semester>(_Key.resultDetails, makeResultDetailKey);

  String makeResultKey(SchoolYear schoolYear, Semester semester) => "$schoolYear/$semester";

  String makeResultDetailKey(String classId, SchoolYear schoolYear, Semester semester) =>
      "$classId/$schoolYear/$semester";

  ExamResultStorageBox(this.box);
}

class ExamResultStorage implements ExamResultDao {
  final ExamResultStorageBox box;

  ExamResultStorage(Box<dynamic> hive) : box = ExamResultStorageBox(hive);

  @override
  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.results.make(schoolYear, semester);
    return cacheKey.value;
  }

  @override
  Future<List<ExamResultDetail>?> getResultDetail(String classId, SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.resultDetails.make(classId, schoolYear, semester);
    return cacheKey.value;
  }

  void setResultList(SchoolYear schoolYear, Semester semester, List<ExamResult>? results) {
    final cacheKey = box.results.make(schoolYear, semester);
    cacheKey.value = results;
  }

  void setResultDetail(String classId, SchoolYear schoolYear, Semester semester, List<ExamResultDetail>? detail) {
    final cacheKey = box.resultDetails.make(classId, schoolYear, semester);
    cacheKey.value = detail;
  }
}
