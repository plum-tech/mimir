import 'package:collection/collection.dart';
import 'package:sit/school/entity/school.dart';

import 'entity/result.ug.dart';
import 'init.dart';

class ExamResultAggregated {
  static Future<Map<SemesterInfo, List<ExamResultUg>>> fetchAndCacheExamResultUgEachSemester() async {
    final list = await ExamResultInit.ugService.fetchResultList(SemesterInfo.all);
    final semester2List = list.groupListsBy((result) => result.semesterInfo);
    final storage = ExamResultInit.ugStorage;
    for (final MapEntry(key: semester, value: list) in semester2List.entries) {
      await storage.setResultList(semester, list);
    }
    return semester2List;
  }
}
