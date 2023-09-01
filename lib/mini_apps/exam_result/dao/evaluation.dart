import '../entity/evaluation.dart';

abstract class CourseEvaluationDao {
  Future<List<CourseToEvaluate>> getEvaluationList();
}
