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
        to.scoreSummary = res;
        return res;
      } catch (e) {
        return to.scoreSummary;
      }
    } else {
      return to.scoreSummary;
    }
  }

  Future<List<Class2ndScoreItem>?> getScoreList() async {
    if (to.box.myScoreList.needRefresh(after: expiration)) {
      try {
        final res = await from.getMyScoreList();
        to.scoreList =res;
        return res;
      } catch (e) {
        return to.scoreList;
      }
    } else {
      return to.scoreList;
    }
  }

  Future<List<Class2ndActivityApplication>?> getAttended() async {
    if (to.box.myInvolved.needRefresh(after: expiration)) {
      try {
        final res = await from.getAttended();
        to.attended = res;
        return res;
      } catch (e) {
        return to.attended;
      }
    } else {
      return to.attended;
    }
  }
}
