import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/school/entity/school.dart';

import '../entity/result.ug.dart';

class _K {
  static const ns = "/ug";
  static const lastSemesterInfo = "$ns/lastSemesterInfo";

  static String resultList(SemesterInfo info) => "$ns/resultList/$info";
}

class ExamResultUgStorage {
  Box get box => HiveInit.examResult;

  const ExamResultUgStorage();

  List<ExamResultUg>? getResultList(SemesterInfo info) =>
      (box.safeGet(_K.resultList(info)) as List?)?.cast<ExamResultUg>();

  Future<void> setResultList(SemesterInfo info, List<ExamResultUg>? results) =>
      box.safePut(_K.resultList(info), results);

  ValueListenable<Box> listenResultList(SemesterInfo info) => box.listenable(keys: [_K.resultList(info)]);

  SemesterInfo? get lastSemesterInfo => box.safeGet(_K.lastSemesterInfo);

  set lastSemesterInfo(SemesterInfo? newV) => box.safePut(_K.lastSemesterInfo, newV);

  Stream<BoxEvent> watchResultList(SemesterInfo Function() getFilter) =>
      box.watch().where((event) => event.key == _K.resultList(getFilter()));
}
