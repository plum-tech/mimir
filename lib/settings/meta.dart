import 'package:hive_flutter/hive_flutter.dart';

class _K {
  static const lastLaunchTime = "/lastLaunchTime";
  static const thisLaunchTime = "/thisLaunchTime";
}

// ignore: non_constant_identifier_names
late MetaImpl Meta;

class MetaImpl {
  final Box box;

  const MetaImpl(this.box);

  DateTime? get lastLaunchTime => box.get(_K.lastLaunchTime);

  set lastLaunchTime(DateTime? newV) => box.put(_K.lastLaunchTime, newV);

  DateTime? get thisLaunchTime => box.get(_K.thisLaunchTime);

  set thisLaunchTime(DateTime? newV) => box.put(_K.thisLaunchTime, newV);
}
