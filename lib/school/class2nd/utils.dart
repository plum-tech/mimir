List<String> extractTitle(String fullTitle) {
  List<String> result = [];

  int lastPos = 0;
  for (int i = 0; i < fullTitle.length; ++i) {
    if (fullTitle[i] == '[' || fullTitle[i] == '【') {
      lastPos = i + 1;
    } else if (fullTitle[i] == ']' || fullTitle[i] == '】') {
      final newTag = fullTitle.substring(lastPos, i);
      if (newTag.isNotEmpty) {
        result.add(newTag);
      }
      lastPos = i + 1;
    }
  }

  result.add(fullTitle.substring(lastPos));
  return result;
}

List<String> cleanDuplicate(List<String> tags) {
  return tags.toSet().toList();
}

({String title, List<String> tags}) splitTitleAndTags(String fullTitle) {
  final titleParts = extractTitle(fullTitle);
  var realTitle = titleParts.isNotEmpty ? titleParts.last : "";
  /*if (realTitle.startsWith(RegExp(r'[:：]'))) {
    realTitle = fullTitle.substring(1);
  }*/
  if (titleParts.isNotEmpty) titleParts.removeLast();
  final tags = cleanDuplicate(titleParts);
  return (title: realTitle, tags: tags);
}
