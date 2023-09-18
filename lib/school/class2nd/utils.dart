import 'package:mimir/school/class2nd/cache/score.dart';

import 'entity/score.dart';

Future<List<ScJoinedActivity>?> getMyActivityListJoinScore(Class2ndScoreCache scScoreDao) async {
  final activities = await scScoreDao.getAttended();
  if (activities == null) return null;
  final scores = await scScoreDao.getScoreList();
  if (scores == null) return null;
  return activities.map((application) {
    // 对于每一次申请, 找到对应的加分信息
    final totalScore = scores
        .where((e) => e.activityId == application.activityId)
        .fold<double>(0.0, (double p, Class2ndScoreItem e) => p + e.amount);
    // TODO: 潜在的 BUG，可能导致得分页面出现重复项。
    return ScJoinedActivity(application.applyId, application.activityId, application.title, application.time,
        application.status, totalScore);
  }).toList();
}

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

class TitleAndTags {
  final String title;
  final List<String> tags;

  const TitleAndTags(this.title, this.tags);
}

TitleAndTags splitTitleAndTags(String fullTitle) {
  final titleParts = extractTitle(fullTitle);
  var realTitle = titleParts.isNotEmpty ? titleParts.last : "";
  /*if (realTitle.startsWith(RegExp(r'[:：]'))) {
    realTitle = fullTitle.substring(1);
  }*/
  if (titleParts.isNotEmpty) titleParts.removeLast();
  final tags = cleanDuplicate(titleParts);
  return TitleAndTags(realTitle, tags);
}
