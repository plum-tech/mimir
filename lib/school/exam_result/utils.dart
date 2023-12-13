import 'entity/result.ug.dart';

double calcGPA(Iterable<ExamResultUg> resultList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  for (final s in resultList) {
    final score = s.score;
    assert(score != null && score >= 0, "Exam score should be >= 0");
    if (score == null) continue;
    totalCredits += s.credit;
    sum += s.credit * score;
  }
  final res = sum / totalCredits / 10.0 - 5.0;
  return res.isNaN ? 0 : res;
}
