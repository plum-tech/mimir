import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/utils/json.dart';

import '../entity/exam.dart';

class _K {
  static const lastSemesterInfo = "/lastSemesterInfo";

  static String examList(SemesterInfo info) => "/examList/$info";
}

class ExamArrangeStorage {
  Box get box => HiveInit.examArrange;

  ExamArrangeStorage();

  List<ExamEntry>? getExamList(SemesterInfo info) =>
      decodeJsonList(box.safeGet(_K.examList(info)), (e) => ExamEntry.fromJson(e));

  void setExamList(SemesterInfo info, List<ExamEntry>? exams) =>
      box.safePut(_K.examList(info), encodeJsonList(exams, (e) => e.toJson()));

  SemesterInfo? get lastSemesterInfo => box.safeGet(_K.lastSemesterInfo);

  set lastSemesterInfo(SemesterInfo? newV) => box.safePut(_K.lastSemesterInfo, newV);

  Stream<BoxEvent> watchExamList(SemesterInfo Function() getFilter) =>
      box.watch().where((event) => event.key == _K.examList(getFilter()));

  late final $examListFamily = box.streamChangeProviderFamily();

  ChangeNotifierProvider<BoxChangeStreamNotifier> $examListFamilyWithSemester(SemesterInfo semester) {
    return $examListFamily((event) => event.key == _K.examList(semester));
  }
}
