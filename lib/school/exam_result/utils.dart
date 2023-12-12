import 'entity/result.ug.dart';

double calcGPA(Iterable<ExamResultUg> resultList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  for (final s in resultList) {
    assert(s.score >= 0, "Exam score should be >= 0");
    totalCredits += s.credit;
    sum += s.credit * s.score;
  }
  final res = sum / totalCredits / 10.0 - 5.0;
  return res.isNaN ? 0 : res;
}
