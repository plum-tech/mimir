import 'package:hive_flutter/hive_flutter.dart';
import 'package:version/version.dart';

class _K {
  static const ns = "/meta";
  static const lastVersion = "$ns/lastVersion";
  static const lastStartupTime = "$ns/lastStartupTime";
  static const installTime = '$ns/installTime';
}

late MetaImpl Meta;

class MetaImpl {
  final Box<dynamic> box;

  const MetaImpl(this.box);

  Version? get lastVersion => box.get(_K.lastVersion);

  set lastVersion(Version? newV) => box.put(_K.lastVersion, newV);

  DateTime? get lastStartupTime => box.get(_K.lastStartupTime);

  set lastStartupTime(DateTime? newV) => box.put(_K.lastStartupTime, newV);

  DateTime get installTime {
    final time = box.get(_K.installTime);
    if (time != null) return time;
    final now = DateTime.now();
    box.put(_K.installTime, now);
    return now;
  }

  set installTime(DateTime newV) => box.put(_K.installTime, newV);
}
