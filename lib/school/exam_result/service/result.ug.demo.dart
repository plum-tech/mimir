import 'dart:math';

import 'package:sit/school/entity/school.dart';
import 'package:sit/school/utils.dart';

import '../entity/result.ug.dart';
import 'result.ug.dart';

class DemoExamResultUgService implements ExamResultUgService {
  const DemoExamResultUgService();

  @override
  Future<List<ExamResultUg>> fetchResultList(
    SemesterInfo info, {
    void Function(double progress)? onProgress,
  }) async {
    onProgress?.call(1.0);
    final now = DateTime.now();
    final SemesterInfo(:exactYear, :semester) = estimateCurrentSemester();
    final rand= Random();
    return List.generate(15, (index){
      final score = rand.nextInt(100).toDouble();
      return ExamResultUg(
        score: score,
        courseName: "小应生活开发实训${rand.nextInt(10)}",
        courseCode: "SIT-Life-${rand.nextInt(100)}",
        innerClassId: "SIT-Life-${rand.nextInt(100)}",
        year: exactYear,
        semester: semester,
        credit: 6.0,
        classCode: "Liplum-Dev",
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
