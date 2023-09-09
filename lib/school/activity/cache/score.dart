import '../storage/score.dart';

import '../dao/score.dart';
import '../entity/score.dart';

class ScScoreCache extends ScScoreDao {
  final ScScoreDao from;
  final ScScoreStorage to;
  Duration expiration;

  ScScoreCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<ScScoreSummary?> getScoreSummary() async {
    if (to.box.myScoreSummary.needRefresh(after: expiration)) {
      try {
        final res = await from.getScoreSummary();
        to.setScScoreSummary(res);
        return res;
      } catch (e) {
        return to.getScoreSummary();
      }
    } else {
      return to.getScoreSummary();
    }
  }

  @override
  Future<List<ScScoreItem>?> getMyScoreList() async {
    if (to.box.myScoreList.needRefresh(after: expiration)) {
      try {
        final res = await from.getMyScoreList();
        to.setMyScoreList(res);
        return res;
      } catch (e) {
        return to.getMyScoreList();
      }
    } else {
      return to.getMyScoreList();
    }
  }

  @override
  Future<List<ScActivityApplication>?> getMyInvolved() async {
    if (to.box.myInvolved.needRefresh(after: expiration)) {
      try {
        final res = await from.getMyInvolved();
        to.setMeInvolved(res);
        return res;
      } catch (e) {
        return to.getMyInvolved();
      }
    } else {
      return to.getMyInvolved();
    }
  }
}
