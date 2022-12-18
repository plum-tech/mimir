import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/storage/dao/report.dart';

class _Key {
  static const namespace = '/report';
  static const enable = '$namespace/enable';
  static const time = '$namespace/time';
}

class ReportStorage implements ReportStorageDao {
  final Box<dynamic> box;

  ReportStorage(this.box);

  @override
  bool? get enable => box.get(_Key.enable);
  @override
  set enable(bool? val) => box.put(_Key.enable, val);

  @override
  DateTime? get time => box.get(_Key.time);
  @override
  set time(DateTime? val) => box.put(_Key.time, val);
}
