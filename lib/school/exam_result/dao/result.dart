import '../entity/result.dart';
import 'package:mimir/school/entity/school.dart';

abstract class ExamResultDao {
  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester);

  Future<List<ExamResultDetails>?> getResultDetail(String classId, SchoolYear schoolYear, Semester semester);
}
