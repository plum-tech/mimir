({String title, List<String> tags}) extractTitle(String fullTitle) {
  List<String> tags = [];

  int lastPos = 0;
  for (int i = 0; i < fullTitle.length; ++i) {
    if (fullTitle[i] == '[') {
      lastPos = i + 1;
    } else if (fullTitle[i] == ']') {
      final newTag = fullTitle.substring(lastPos, i);
      if (newTag.isNotEmpty) {
        tags.addAll(newTag.split("&"));
      }
      lastPos = i + 1;
    }
  }

  return (tags: tags, title: fullTitle.substring(lastPos));
}

List<String> cleanDuplicate(List<String> tags) {
  return tags.toSet().toList();
}

({String title, List<String> tags}) splitTitleAndTags(String fullTitle) {
  var (:title, :tags) = extractTitle(fullTitle);
  tags = cleanDuplicate(tags);
  return (title: title, tags: tags);
}
