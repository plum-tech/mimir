import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/school/utils.dart';

import '../entity/result.ug.dart';
import 'result.ug.dart';

const _names = ["开发", "设计", "部署", "国际化"];

class DemoExamResultUgService implements ExamResultUgService {
  const DemoExamResultUgService();

  @override
  Future<List<ExamResultUg>> fetchResultList(
    SemesterInfo info, {
    void Function(double progress)? onProgress,
  }) async {
    onProgress?.call(1.0);
    final now = DateTime.now();
    final SemesterInfo(:exactYear, :semester) = estimateSemesterInfo();
    final rand = Random();
    await Future.delayed(const Duration(milliseconds: 1560));
    return List.generate(15, (index) {
      final score = (rand.nextInt(50) + 50).toDouble();
      return ExamResultUg(
        score: score,
        courseName: "小应生活${_names.random(rand)}实训${rand.nextInt(10)}",
        courseCode: "SIT-Life-${rand.nextInt(100)}",
        innerClassId: "SIT-Life-${rand.nextInt(100)}",
        year: exactYear,
        semester: semester,
        credit: 6.0,
        classCode: "dev-${score}",
        time: now.copyWith(day: now.day - rand.nextInt(10)),
        courseCat: CourseCat.publicCore,
        examType: UgExamType.normal,
        teachers: ["Liplum"],
        items: [
          ExamResultItem(
            scoreType: 'A',
            percentage: '50%',
            score: score * 0.5,
          ),
          ExamResultItem(
            scoreType: 'B',
            percentage: '50%',
            score: score * 0.5,
          ),
        ],
      );
    });
  }
}
