import 'package:mimir/school/class2nd/service/score.dart';

import '../storage/score.dart';

import '../entity/score.dart';

class Class2ndScoreCache {
  final Class2ndScoreService from;
  final Class2ndScoreStorage to;
  Duration expiration;

  Class2ndScoreCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  Future<Class2ndScoreSummary?> getScoreSummary() async {
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

  Future<List<Class2ndScoreItem>?> getMyScoreList() async {
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

  Future<List<Class2ndActivityApplication>?> getMyInvolved() async {
    if (to.box.myInvolved.needRefresh(after: expiration)) {
      try {
        final res = await from.getAttended();
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
