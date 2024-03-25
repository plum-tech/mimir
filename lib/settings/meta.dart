import 'package:sit/utils/hive.dart';
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

  DateTime? get lastLaunchTime => box.safeGet(_K.lastLaunchTime);

  set lastLaunchTime(DateTime? newV) => box.safePut(_K.lastLaunchTime, newV);

  DateTime? get thisLaunchTime => box.safeGet(_K.thisLaunchTime);

  set thisLaunchTime(DateTime? newV) => box.safePut(_K.thisLaunchTime, newV);
}
