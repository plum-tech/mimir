import '../entity/exam.dart';
import '../using.dart';

abstract class ExamDao {
  Future<List<ExamEntry>?> getExamList(SchoolYear schoolYear, Semester semester);
}
