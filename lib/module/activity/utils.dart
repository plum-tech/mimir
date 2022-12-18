import 'dao/score.dart';
import 'entity/score.dart';

Future<List<ScJoinedActivity>?> getMyActivityListJoinScore(ScScoreDao scScoreDao) async {
  final activities = await scScoreDao.getMyInvolved();
  if (activities == null) return null;
  final scores = await scScoreDao.getMyScoreList();
  if (scores == null) return null;
  return activities.map((application) {
    // 对于每一次申请, 找到对应的加分信息
    final totalScore = scores
        .where((e) => e.activityId == application.activityId)
        .fold<double>(0.0, (double p, ScScoreItem e) => p + e.amount);
    // TODO: 潜在的 BUG，可能导致得分页面出现重复项。
    return ScJoinedActivity(application.applyId, application.activityId, application.title, application.time,
        application.status, totalScore);
  }).toList();
}
