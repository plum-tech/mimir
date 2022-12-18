import '../entity/course.dart';

Future<List<Course>> fetchMockCourses() async {
  return await Future(() => [
        Course("Name A", 0, 0, "Place A", ["Teacher A", "Teacher B"], "Campus A", 2.0, 2, "Class ID", "Course ID",
            "Week Text")
      ]);
}
