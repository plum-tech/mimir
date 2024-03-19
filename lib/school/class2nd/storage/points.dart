import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/application.dart';
import '../entity/attended.dart';

class _K {
  static const pointsSummary = "/pointsSummary";
  static const pointItemList = "/pointItemList";
  static const applicationList = "/applicationList";
}

class Class2ndPointsStorage {
  Box get box => HiveInit.class2nd;

  const Class2ndPointsStorage();

  Class2ndPointsSummary? get pointsSummary => box.get(_K.pointsSummary);

  set pointsSummary(Class2ndPointsSummary? newValue) => box.put(_K.pointsSummary, newValue);

  ValueListenable<Box> listenPointsSummary() => box.listenable(keys: [_K.pointsSummary]);

  List<Class2ndPointItem>? get pointItemList => (box.get(_K.pointItemList) as List?)?.cast<Class2ndPointItem>();

  set pointItemList(List<Class2ndPointItem>? newValue) => box.put(_K.pointItemList, newValue);

  List<Class2ndActivityApplication>? get applicationList =>
      (box.get(_K.applicationList) as List?)?.cast<Class2ndActivityApplication>();

  set applicationList(List<Class2ndActivityApplication>? newValue) => box.put(_K.applicationList, newValue);
}
