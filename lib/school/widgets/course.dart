import 'package:flutter/widgets.dart';
import 'package:mimir/school/entity/school.dart';

class CourseIcon extends StatelessWidget {
  final String courseName;

  const CourseIcon({
    super.key,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      CourseCategory.iconPathOf(courseName: courseName),
    );
  }
}
