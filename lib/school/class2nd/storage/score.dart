import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/score.dart';

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

class ScScoreStorage {
  final ScScoreStorageBox box;

  ScScoreStorage(Box<dynamic> hive) : box = ScScoreStorageBox(hive);

  Future<ScScoreSummary?> getScoreSummary() async {
    return box.myScoreSummary.value;
  }

  Future<List<ScScoreItem>?> getMyScoreList() async {
    return box.myScoreList.value;
  }

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
