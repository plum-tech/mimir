import 'package:collection/collection.dart';
import 'package:sit/school/entity/school.dart';

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

List<ExamResultUg> filterGpaAvailableResult(List<ExamResultUg> list) {
  return list.where((result) => !result.isPreparatory).toList();
}

List<({SemesterInfo semester, List<ExamResultUg> result})> groupExamResultList(List<ExamResultUg> list) {
  final semester2Result = list.groupListsBy((result) => result.semesterInfo);
  final groups = semester2Result.entries.map((entry) => (semester: entry.key, result: entry.value)).toList();
  groups.sortBy((group) => group.semester);
  return groups;
}
