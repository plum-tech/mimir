import '../entity/exam.dart';
import 'package:mimir/school/entity/school.dart';

import 'exam.dart';

class DemoExamArrangeService implements ExamArrangeService {
  const DemoExamArrangeService();

  @override
  Future<List<ExamEntry>> fetchExamList(SemesterInfo info) async {
    final now = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 1450));
    return [
      ExamEntry(
        courseName: "小应生活设计实训",
        place: "会议厅",
        campus: "奉贤",
        time: (start: now.copyWith(day: now.day + 1), end: now.copyWith(day: now.day + 1, hour: now.hour + 1)),
        seatNumber: 9,
      ),
      ExamEntry(
        courseName: "小应生活部署实训",
        place: "运维中心",
        campus: "奉贤",
        time: (start: now.copyWith(day: now.day + 1), end: now.copyWith(day: now.day + 1, hour: now.hour + 1)),
        seatNumber: 9,
        isRetake: true,
      ),
      ExamEntry(
        courseName: "小应生活开发实训",
        place: "机房",
        campus: "奉贤",
        time: (start: now.copyWith(day: now.day + 4), end: now.copyWith(day: now.day + 1, hour: now.hour + 1)),
        seatNumber: 18,
        disqualified: true,
      ),
    ];
  }
}
