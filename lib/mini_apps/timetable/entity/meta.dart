class TimetableMeta {
  final String name;
  final String description;
  final DateTime startDate;
  final int schoolYear;
  final int semester;

  const TimetableMeta({
    required this.name,
    required this.description,
    required this.startDate,
    required this.schoolYear,
    required this.semester,
  });

  TimetableMeta copyWith({
    String? name,
    String? description,
    DateTime? startDate,
    int? schoolYear,
    int? semester,
  }) {
    return TimetableMeta(
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      schoolYear: schoolYear ?? this.schoolYear,
      semester: semester ?? this.semester,
    );
  }

  @override
  String toString() {
    return 'TimetableMeta{name: $name, description: $description, startDate: $startDate, schoolYear: $schoolYear, semester: $semester}';
  }
}
