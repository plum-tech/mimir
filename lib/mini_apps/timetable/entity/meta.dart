class TimetableMeta {
  final String name;
  final DateTime startDate;
  final int schoolYear;
  final int semester;

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
    int? semester,
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
