import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/application.dart';

class _K {
  static const ns = "/application";

  static String applicationListOf(YwbApplicationType type) => "$ns/$type";
}

class YwbApplicationStorage {
  Box get box => HiveInit.ywb;

  const YwbApplicationStorage();

  List<YwbApplication>? getApplicationListOf(YwbApplicationType type) =>
      (box.get(_K.applicationListOf(type)) as List?)?.cast<YwbApplication>();

  Future<void> setApplicationListOf(YwbApplicationType type, List<YwbApplication>? newV) =>
      box.put(_K.applicationListOf(type), newV);

  Listenable listenApplicationListOf(YwbApplicationType type) => box.listenable(keys: [_K.applicationListOf(type)]);
}
