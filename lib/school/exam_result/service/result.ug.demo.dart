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
    // TODO: l10n
    onProgress?.call(1.0);
    final now = DateTime.now();
    final SemesterInfo(:exactYear, :semester) = estimateCurrentSemester();
    return [
      ExamResultUg(
        score: 100.0,
        courseName: "小应生活开发实训",
        courseCode: "SIT-Life-001",
        innerClassId: "SIT-Life-001",
        year: exactYear,
        semester: semester,
        credit: 6.0,
        classCode: "Liplum-Dev",
        time: now.copyWith(day: now.day - 1),
        courseCat: CourseCat.publicCore,
        examType: UgExamType.normal,
        teachers: ["Liplum"],
        items: [
          const ExamResultItem(
            scoreType: 'A',
            percentage: '50%',
            score: 50.0,
          ),
          const ExamResultItem(
            scoreType: 'B',
            percentage: '50%',
            score: 50.0,
          ),
        ],
      ),
      ExamResultUg(
        score: 60.0,
        courseName: "小应生活设计实训",
        courseCode: "SIT-Life-002",
        innerClassId: "SIT-Life-002",
        year: exactYear,
        semester: semester,
        credit: 3.0,
        classCode: "Liplum-Dev",
        time: now.copyWith(day: now.day - 2),
        courseCat: CourseCat.publicCore,
        examType: UgExamType.resit,
        teachers: ["Liplum"],
        items: [
          const ExamResultItem(
            scoreType: 'A',
            percentage: '50%',
            score: 100.0,
          ),
          const ExamResultItem(
            scoreType: 'B',
            percentage: '50%',
            score: 20.0,
          ),
        ],
      ),
      ExamResultUg(
        score: 59.0,
        courseName: "小应生活设计实训",
        courseCode: "SIT-Life-002",
        innerClassId: "SIT-Life-002",
        year: exactYear,
        semester: semester,
        credit: 3.0,
        classCode: "Liplum-Dev",
        time: now.copyWith(day: now.day - 3),
        courseCat: CourseCat.publicCore,
        examType: UgExamType.normal,
        teachers: ["Liplum"],
        items: [
          const ExamResultItem(
            scoreType: 'A',
            percentage: '50%',
            score: 98.0,
          ),
          const ExamResultItem(
            scoreType: 'B',
            percentage: '50%',
            score: 20.0,
          ),
        ],
      ),
    ];
  }
}
