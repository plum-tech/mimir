import 'package:mimir/school/entity/school.dart';
import 'package:mimir/school/exam_arrange/service/exam.dart';

import '../entity/exam.dart';
import '../storage/exam.dart';

class ExamCache {
  final ExamService from;
  final ExamStorage to;
  Duration expiration;

  ExamCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  Future<List<ExamEntry>?> getExamList({
    required SchoolYear year,
    required Semester semester,
  }) async {
    final cacheKey = to.box.exams.make(year, semester);
    if (cacheKey.needRefresh(after: expiration)) {
      try {
        final res = await from.getExamList(year: year, semester: semester);
        to.setExamList(res, year: year, semester: semester);
        return res;
      } catch (e) {
        return to.getExamList(year: year, semester: semester);
      }
    } else {
      return to.getExamList(year: year, semester: semester);
    }
  }
}
