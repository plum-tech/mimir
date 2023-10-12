import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/school/entity/school.dart';

const _kClass2ndAutoRefresh = true;

class SchoolSettings {
  final Box box;

  SchoolSettings(this.box);

  late final class2nd = _Class2nd(box);
  late final examResult = _ExamResult(box);
  late final examArrange = _ExamArrange(box);

  static const ns = "/school";
}

class _Class2ndK {
  static const ns = "${SchoolSettings.ns}/class2nd";
  static const autoRefresh = "$ns/autoRefresh";
}

class _Class2nd {
  final Box box;

  const _Class2nd(this.box);

  bool get autoRefresh => box.get(_Class2ndK.autoRefresh) ?? _kClass2ndAutoRefresh;

  set autoRefresh(bool newV) => box.put(_Class2ndK.autoRefresh, newV);
}

const _kExamResulAppCardShowResultDetails = false;

class _ExamResultK {
  static const ns = "${SchoolSettings.ns}/examResult";
  static const appCardShowResultDetails = "$ns/appCardShowResultDetails";
  static const lastSemesterInfo = "$ns/lastSemesterInfo";
}

class _ExamResult {
  final Box box;

  const _ExamResult(this.box);

  bool get appCardShowResultDetails =>
      box.get(_ExamResultK.appCardShowResultDetails) ?? _kExamResulAppCardShowResultDetails;

  set appCardShowResultDetails(bool newV) => box.put(_ExamResultK.appCardShowResultDetails, newV);

  ValueListenable<Box> listenAppCardShowResultDetails() =>
      box.listenable(keys: [_ExamResultK.appCardShowResultDetails]);

  SemesterInfo? get lastSemesterInfo {
    final Semester? semester = box.get("${_ExamResultK.lastSemesterInfo}/semester");
    final int? year = box.get("${_ExamResultK.lastSemesterInfo}/year");
    if (semester != null && year != null) {
      return (semester: semester, year: year);
    }
    return null;
  }

  set lastSemesterInfo(SemesterInfo? newV) {
    box.put("${_ExamResultK.lastSemesterInfo}/semester", newV?.semester);
    box.put("${_ExamResultK.lastSemesterInfo}/year", newV?.year);
  }
}

class _ExamArrangeK {
  static const ns = "${SchoolSettings.ns}/examArrange";
  static const lastSemesterInfo = "$ns/lastSemesterInfo";
}

class _ExamArrange {
  final Box box;

  const _ExamArrange(this.box);

  SemesterInfo? get lastSemesterInfo {
    final Semester? semester = box.get("${_ExamArrangeK.lastSemesterInfo}/semester");
    final int? year = box.get("${_ExamArrangeK.lastSemesterInfo}/year");
    if (semester != null && year != null) {
      return (semester: semester, year: year);
    }
    return null;
  }

  set lastSemesterInfo(SemesterInfo? newV) {
    box.put("${_ExamArrangeK.lastSemesterInfo}/semester", newV?.semester);
    box.put("${_ExamArrangeK.lastSemesterInfo}/year", newV?.year);
  }
}
