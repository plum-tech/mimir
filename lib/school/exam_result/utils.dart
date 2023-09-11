import 'entity/result.dart';

double calcGPA(Iterable<ExamResult> scoreList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  for (final s in scoreList) {
    assert(s.score >= 0, "Exam score should be >= 0");
    totalCredits += s.credit;
    sum += s.credit * s.score;
  }
  final res = sum / totalCredits / 10.0 - 5.0;
  return res.isNaN ? 0 : res;
}
