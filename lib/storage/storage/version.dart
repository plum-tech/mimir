import 'package:hive/hive.dart';
import 'package:version/version.dart';

import '../dao/version.dart';

class _Key {
  static const ns = "/version";
  static const lastVersion = "$ns/lastVersion";
  static const lastStartupTime = "$ns/lastStartupTime";
}

class VersionStorage implements VersionDao {
  final Box<dynamic> box;

  VersionStorage(this.box);

  @override
  Version? get lastVersion => box.get(_Key.lastVersion);

  @override
  set lastVersion(Version? newV) => box.put(_Key.lastVersion, newV);

  @override
  DateTime? get lastStartupTime => box.get(_Key.lastStartupTime);

  @override
  set lastStartupTime(DateTime? newV) => box.put(_Key.lastStartupTime, newV);
}
