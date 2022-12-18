import '../entity/result.dart';
import '../using.dart';

abstract class ExamResultDao {
  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester);

  Future<List<ExamResultDetail>?> getResultDetail(String classId, SchoolYear schoolYear, Semester semester);
}
