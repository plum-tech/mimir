import '../entity/exam.dart';
import 'package:sit/school/entity/school.dart';

import 'exam.dart';

class DemoExamArrangeService implements ExamArrangeService {
  const DemoExamArrangeService();

  @override
  Future<List<ExamEntry>> fetchExamList(SemesterInfo info) async {
    // TODO: l10n
    final now = DateTime.now();
    return [
      ExamEntry(
        courseName: "小应生活开发实训",
        place: "小应生活实验室",
        campus: "奉贤",
        time: (start: now.copyWith(day: now.day + 1), end: now.copyWith(day: now.day + 1, hour: now.hour + 1)),
        seatNumber: 9,
        isRetake: true,
      ),
    ];
  }
}
