import 'dart:math';

import '../entity/result.pg.dart';
import 'result.pg.dart';

class DemoExamResultPgService implements ExamResultPgService {
  const DemoExamResultPgService();

  @override
  Future<List<ExamResultPgRaw>> fetchResultRawList() async {
    return [];
  }

  @override
  Future<List<ExamResultPg>> fetchResultList() async {
    final now = DateTime.now();
    final rand = Random();
    return List.generate(15, (index) {
      final score = (rand.nextInt(50) + 50).toDouble();
      return ExamResultPg(
        score: score,
        courseName: "小应生活开发实训${rand.nextInt(10)}",
        courseCode: "SIT-Life-${rand.nextInt(100)}",
        examType: '考试',
        courseType: "必修",
        credit: 2,
        teacher: "Liplum",
        notes: "",
        time: now.copyWith(day: now.day - rand.nextInt(10)),
        passed: score >= 60,
        form: '',
      );
    });
  }
}
