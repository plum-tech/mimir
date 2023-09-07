import '../entity/exam.dart';
import 'package:mimir/school/entity/school.dart';

abstract class ExamDao {
  Future<List<ExamEntry>?> getExamList(SchoolYear schoolYear, Semester semester);
}
