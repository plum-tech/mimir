import 'package:hive/hive.dart';
import 'package:mimir/mini_apps/activity/dao/score.dart';

import '../entity/score.dart';
import '../using.dart';

class _Key {
  static const scScoreSummary = "/myScoreSummary";
  static const scoreList = "/myScoreList";
  static const meInvolved = "/myInvolved";
}

class ScScoreStorageBox with CachedBox {
  @override
  final Box<dynamic> box;

  ScScoreStorageBox(this.box);

  late final myScoreSummary = Named<ScScoreSummary>(_Key.scScoreSummary);
  late final myScoreList = NamedList<ScScoreItem>(_Key.scoreList);
  late final myInvolved = NamedList<ScActivityApplication>(_Key.meInvolved);
}

class ScScoreStorage extends ScScoreDao {
  final ScScoreStorageBox box;

  ScScoreStorage(Box<dynamic> hive) : box = ScScoreStorageBox(hive);

  @override
  Future<ScScoreSummary?> getScoreSummary() async {
    return box.myScoreSummary.value;
  }

  @override
  Future<List<ScScoreItem>?> getMyScoreList() async {
    return box.myScoreList.value;
  }

  @override
  Future<List<ScActivityApplication>?> getMyInvolved() async {
    return box.myInvolved.value;
  }

  void setMeInvolved(List<ScActivityApplication>? list) {
    box.myInvolved.value = list;
  }

  void setScScoreSummary(ScScoreSummary? summery) {
    box.myScoreSummary.value = summery;
  }

  void setMyScoreList(List<ScScoreItem>? list) {
    box.myScoreList.value = list;
  }
}
