int? getAdmissionYearFromStudentId(String? studentId) {
  if (studentId == null) return null;
  final fromID = int.tryParse(studentId.substring(0, 2));
  if (fromID != null) {
    return 2000 + fromID;
  }
  return null;
}
