import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/score.dart';

class _Key {
  static const scScoreSummary = "/myScoreSummary";
  static const scoreList = "/myScoreList";
  static const meInvolved = "/myInvolved";
}

class Class2ndScoreStorageBox with CachedBox {
  @override
  final Box<dynamic> box;

  Class2ndScoreStorageBox(this.box);

  late final myScoreSummary = named<Class2ndScoreSummary>(_Key.scScoreSummary);
  late final myScoreList = namedList<Class2ndScoreItem>(_Key.scoreList);
  late final myInvolved = namedList<Class2ndActivityApplication>(_Key.meInvolved);
}

class Class2ndScoreStorage {
  final Class2ndScoreStorageBox box;

  Class2ndScoreStorage(Box<dynamic> hive) : box = Class2ndScoreStorageBox(hive);

  Future<Class2ndScoreSummary?> getScoreSummary() async {
    return box.myScoreSummary.value;
  }

  Future<List<Class2ndScoreItem>?> getMyScoreList() async {
    return box.myScoreList.value;
  }

  Future<List<Class2ndActivityApplication>?> getMyInvolved() async {
    return box.myInvolved.value;
  }

  void setMeInvolved(List<Class2ndActivityApplication>? list) {
    box.myInvolved.value = list;
  }

  void setScScoreSummary(Class2ndScoreSummary? summery) {
    box.myScoreSummary.value = summery;
  }

  void setMyScoreList(List<Class2ndScoreItem>? list) {
    box.myScoreList.value = list;
  }
}
