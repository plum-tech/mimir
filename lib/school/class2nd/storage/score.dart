import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/score.dart';

class _K {
  static const scoreSummary = "/scoreSummary";
  static const scoreItemList = "/scoreItemList";
  static const attended = "/attended";
}

class Class2ndScoreStorage {
  final Box<dynamic> box;

  const Class2ndScoreStorage(this.box);

  Class2ndScoreSummary? get scoreSummary => box.get(_K.scoreSummary);

  set scoreSummary(Class2ndScoreSummary? newValue) => box.put(_K.scoreSummary, newValue);

  ValueListenable<Box> get $scoreSummary => box.listenable(keys: [_K.scoreSummary]);

  List<Class2ndScoreItem>? get scoreItemList => (box.get(_K.scoreItemList) as List?)?.cast<Class2ndScoreItem>();

  set scoreItemList(List<Class2ndScoreItem>? newValue) => box.put(_K.scoreItemList, newValue);

  List<Class2ndActivityApplication>? get attended =>
      (box.get(_K.attended) as List?)?.cast<Class2ndActivityApplication>();

  set attended(List<Class2ndActivityApplication>? newValue) => box.put(_K.attended, newValue);
}
