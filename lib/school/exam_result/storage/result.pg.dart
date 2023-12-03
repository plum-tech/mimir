import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/school/exam_result/entity/result.pg.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/school/entity/school.dart';

class _K {
  static const ns = "/ug";

  static const resultList = "$ns/resultList";
}

class ExamResultPgStorage {
  Box get box => HiveInit.examResult;

  const ExamResultPgStorage();

  List<ExamResultPg>? getResultList() => (box.get(_K.resultList) as List?)?.cast<ExamResultPg>();

  Future<void> setResultList(List<ExamResultPg>? newV) => box.put(_K.resultList, newV);

  ValueListenable<Box> listenResultList(SemesterInfo info) => box.listenable(keys: [_K.resultList]);
}
