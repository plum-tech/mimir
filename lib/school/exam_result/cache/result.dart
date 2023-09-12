import 'package:mimir/school/exam_result/service/result.dart';

import '../entity/result.dart';
import '../storage/result.dart';
import 'package:mimir/school/entity/school.dart';

class ExamResultCache {
  final ExamResultService from;
  final ExamResultStorage to;
  Duration detailExpire;
  Duration listExpire;

  ExamResultCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.listExpire = const Duration(minutes: 10),
  });

  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = to.box.results.make(schoolYear, semester);
    if (cacheKey.needRefresh(after: listExpire)) {
      try {
        final res = await from.getResultList(schoolYear, semester);
        to.setResultList(schoolYear, semester, res);
        return res;
      } catch (e) {
        return to.getResultList(schoolYear, semester);
      }
    } else {
      return to.getResultList(schoolYear, semester);
    }
  }

  clearResultListCache() {
    to.box.results.clear();
  }
}
