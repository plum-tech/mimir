import 'package:hive_flutter/hive_flutter.dart';

class _K {
  static const lastStartupTime = "/lastStartupTime";
  static const installTime = '/installTime';
}

// ignore: non_constant_identifier_names
late MetaImpl Meta;

class MetaImpl {
  final Box box;

  const MetaImpl(this.box);

  DateTime? get lastStartupTime => box.get(_K.lastStartupTime);

  set lastStartupTime(DateTime? newV) => box.put(_K.lastStartupTime, newV);

  DateTime? get installTime => box.get(_K.installTime);

  set installTime(DateTime? newV) => box.put(_K.installTime, newV);
}
