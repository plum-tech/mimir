import 'package:sit/school/class2nd/entity/list.dart';

final _tagParenthesesRegx = RegExp(r"\[(.*?)\]");

({String title, List<String> tags}) separateTagsFromTitle(String full) {
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
