import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/score.dart';

class _Key {
  static const scoreSummary = "/scoreSummary";
  static const scoreList = "/scoreList";
  static const attended = "/attended";
}

class Class2ndScoreStorageBox with CachedBox {
  @override
  final Box<dynamic> box;

  Class2ndScoreStorageBox(this.box);

  late final myScoreSummary = named<Class2ndScoreSummary>(_Key.scoreSummary);
  late final myScoreList = namedList<Class2ndScoreItem>(_Key.scoreList);
  late final myInvolved = namedList<Class2ndActivityApplication>(_Key.attended);
}

class Class2ndScoreStorage {
  final Class2ndScoreStorageBox box;

  Class2ndScoreStorage(Box<dynamic> hive) : box = Class2ndScoreStorageBox(hive);

  Class2ndScoreSummary? get scoreSummary => box.myScoreSummary.value;

  set scoreSummary(Class2ndScoreSummary? summery) => box.myScoreSummary.value = summery;

  List<Class2ndScoreItem>? get scoreList => box.myScoreList.value;

  set scoreList(List<Class2ndScoreItem>? list) => box.myScoreList.value = list;

  List<Class2ndActivityApplication>? get attended => box.myInvolved.value;

  set attended(List<Class2ndActivityApplication>? list) => box.myInvolved.value = list;
}
