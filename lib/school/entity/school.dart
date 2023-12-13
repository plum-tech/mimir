import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/storage/hive/type_id.dart';

part 'school.g.dart';

typedef SchoolYear = int;

@HiveType(typeId: CacheHiveType.semester)
@JsonEnum()
enum Semester {
  @HiveField(0)
  all,
  @HiveField(1)
  term1,
  @HiveField(2)
  term2;

  String localized() => "school.semester.$name".tr();
}

@HiveType(typeId: CacheHiveType.semesterInfo)
class SemesterInfo {
  @HiveField(0)
  final SchoolYear year;
  @HiveField(1)
  final Semester semester;

  const SemesterInfo({
    required this.year,
    required this.semester,
  });

  @override
  String toString() {
    return "$year:$semester";
  }

  @override
  bool operator ==(Object other) {
    return other is SemesterInfo &&
        runtimeType == other.runtimeType &&
        year == other.year &&
        semester == other.semester;
  }

  @override
  int get hashCode => Object.hash(year, semester);
}

SemesterInfo estimateCurrentSemester() {
  final now = DateTime.now();
  return SemesterInfo(
    year: now.month >= 9 ? now.year : now.year - 1,
    semester: now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1,
  );
}

String semesterToFormField(Semester semester) {
  const mapping = {
    Semester.all: '',
    Semester.term1: '3',
    Semester.term2: '12',
  };
  return mapping[semester]!;
}
