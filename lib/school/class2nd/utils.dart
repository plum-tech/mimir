import 'package:mimir/school/class2nd/entity/activity.dart';

import 'entity/application.dart';
import 'entity/attended.dart';

final _tagParenthesesRegx = RegExp(r"\[(.*?)\]");

({String title, List<String> tags}) separateTagsFromTitle(String full) {
  if (full.isEmpty) return (title: "", tags: <String>[]);
  final allMatched = _tagParenthesesRegx.allMatches(full);
  final resultTags = <String>[];
  for (final matched in allMatched) {
    final tag = matched.group(1);
    if (tag != null) {
      final tags = tag.split("&");
      for (final tag in tags) {
        resultTags.add(tag.trim());
      }
    }
  }
  final title = full.replaceAll(_tagParenthesesRegx, "");
  return (title: title, tags: resultTags.toSet().toList());
}

const commonClass2ndCategories = [
  Class2ndActivityCat.lecture,
  Class2ndActivityCat.creation,
  Class2ndActivityCat.thematicEdu,
  Class2ndActivityCat.practice,
  Class2ndActivityCat.voluntary,
  Class2ndActivityCat.schoolCultureActivity,
  Class2ndActivityCat.schoolCultureCompetition,
];

List<Class2ndAttendedActivity> buildAttendedActivityList({
  required List<Class2ndActivityApplication> applications,
  required List<Class2ndPointItem> scores,
}) {
  final attended = applications.map((application) {
    final relatedScoreItems = scores.where((e) => e.activityId == application.activityId).toList();
    return Class2ndAttendedActivity(
      application: application,
      scores: relatedScoreItems,
    );
  }).toList();
  return attended;
}

const _targetScores2019 = Class2ndPointsSummary(
  thematicReport: 1.5,
  practice: 2,
  creation: 1.5,
  schoolSafetyCivilization: 1,
  voluntary: 1,
  schoolCulture: 1,
);
const _admissionYear2targetScores = {
  2013: Class2ndPointsSummary(thematicReport: 1, schoolCulture: 1),
  2014: Class2ndPointsSummary(thematicReport: 1, practice: 1, schoolCulture: 1),
  2015: Class2ndPointsSummary(thematicReport: 1, practice: 1, creation: 1, schoolCulture: 1),
  2016: Class2ndPointsSummary(thematicReport: 1, practice: 1, creation: 1, schoolCulture: 1),
  2017: Class2ndPointsSummary(
    thematicReport: 1.5,
    practice: 2,
    creation: 1.5,
    schoolSafetyCivilization: 1,
    schoolCulture: 2,
  ),
  2018: Class2ndPointsSummary(
    thematicReport: 1.5,
    practice: 2,
    creation: 1.5,
    schoolSafetyCivilization: 1,
    schoolCulture: 2,
  ),
  2019: _targetScores2019,
  2020: _targetScores2019,
  2021: _targetScores2019,
  2022: _targetScores2019,
  2023: _targetScores2019,
};

Class2ndPointsSummary getTargetScoreOf({required int? admissionYear}) {
  return _admissionYear2targetScores[admissionYear] ?? _targetScores2019;
}
