final _tagParenthesesRegx = RegExp(r"\[(.*?)\]");

({String title, List<String> tags}) extractTagsFromTitle(String full) {
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
  return (title: title, tags: resultTags);
}

({String title, List<String> tags}) splitTitleAndTags(String fullTitle) {
  var (:title, :tags) = extractTagsFromTitle(fullTitle);
  tags = tags.toSet().toList();
  return (title: title, tags: tags);
}
