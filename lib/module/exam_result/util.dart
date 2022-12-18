import 'entity/result.dart';

/// 计算GPA
double calcGPA(List<ExamResult> scoreList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  for (var s in scoreList) {
    // 跳过未评教的课程
    if (s.value >= 0) {
      totalCredits += s.credit;
      sum += s.credit * s.value;
    }
  }
  return sum / totalCredits / 10.0 - 5.0;
}
