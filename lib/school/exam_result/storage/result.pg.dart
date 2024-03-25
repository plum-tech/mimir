import 'package:flutter/foundation.dart';
import 'package:sit/utils/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/school/exam_result/entity/result.pg.dart';
import 'package:sit/storage/hive/init.dart';

class _K {
  static const ns = "/pg";

  static const resultList = "$ns/resultList";
}

class ExamResultPgStorage {
  Box get box => HiveInit.examResult;

  const ExamResultPgStorage();

  List<ExamResultPg>? getResultList() => (box.safeGet(_K.resultList) as List?)?.cast<ExamResultPg>();

  Future<void> setResultList(List<ExamResultPg>? newV) => box.safePut(_K.resultList, newV);

  ValueListenable<Box> listenResultList() => box.listenable(keys: [_K.resultList]);
}
