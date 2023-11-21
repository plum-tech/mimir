import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/hive/init.dart';

import '../entity/attended.dart';

class _K {
  static const scoreSummary = "/scoreSummary";
  static const scoreItemList = "/scoreItemList";
  static const applicationList = "/applicationList";
  static const attendedList = "/attendedList";
}

class Class2ndScoreStorage {
  Box get box => HiveInit.class2nd;

  const Class2ndScoreStorage();

  Class2ndScoreSummary? get scoreSummary => box.get(_K.scoreSummary);

  set scoreSummary(Class2ndScoreSummary? newValue) => box.put(_K.scoreSummary, newValue);

  ValueListenable<Box> listenScoreSummary() => box.listenable(keys: [_K.scoreSummary]);

  List<Class2ndScoreItem>? get scoreItemList => (box.get(_K.scoreItemList) as List?)?.cast<Class2ndScoreItem>();

  set scoreItemList(List<Class2ndScoreItem>? newValue) => box.put(_K.scoreItemList, newValue);

  List<Class2ndActivityApplication>? get applicationList =>
      (box.get(_K.applicationList) as List?)?.cast<Class2ndActivityApplication>();

  set applicationList(List<Class2ndActivityApplication>? newValue) => box.put(_K.applicationList, newValue);

  List<Class2ndAttendedActivity>? get attendedList =>
      (box.get(_K.attendedList) as List?)?.cast<Class2ndAttendedActivity>();

  set attendedList(List<Class2ndAttendedActivity>? newValue) => box.put(_K.attendedList, newValue);

  ValueListenable<Box> listenAttendedList() => box.listenable(keys: [_K.attendedList]);
}
