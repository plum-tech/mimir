import 'package:mimir/school/entity/school.dart';

class TimetableMeta {
  final String name;
  final DateTime startDate;
  final int schoolYear;
  final Semester semester;

  const TimetableMeta({
    required this.name,
    required this.startDate,
    required this.schoolYear,
    required this.semester,
  });

  TimetableMeta copyWith({
    String? name,
    DateTime? startDate,
    int? schoolYear,
    Semester? semester,
  }) {
    return TimetableMeta(
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      schoolYear: schoolYear ?? this.schoolYear,
      semester: semester ?? this.semester,
    );
  }

  @override
  String toString() {
    return 'TimetableMeta{name: $name, startDate: $startDate, schoolYear: $schoolYear, semester: $semester}';
  }
}
