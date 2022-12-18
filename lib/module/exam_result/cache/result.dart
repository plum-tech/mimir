import '../dao/result.dart';
import '../entity/result.dart';
import '../storage/result.dart';
import '../using.dart';

class ExamResultCache implements ExamResultDao {
  final ExamResultDao from;
  final ExamResultStorage to;
  Duration detailExpire;
  Duration listExpire;

  ExamResultCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.listExpire = const Duration(minutes: 10),
  });

  @override
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

  @override
  Future<List<ExamResultDetail>?> getResultDetail(String classId, SchoolYear schoolYear, Semester semester) async {
    final cacheKey = to.box.resultDetails.make(classId, schoolYear, semester);
    if (cacheKey.needRefresh(after: listExpire)) {
      try {
        final res = await from.getResultDetail(classId, schoolYear, semester);
        to.setResultDetail(classId, schoolYear, semester, res);
        return res;
      } catch (e) {
        return to.getResultDetail(classId, schoolYear, semester);
      }
    } else {
      return to.getResultDetail(classId, schoolYear, semester);
    }
  }
}
