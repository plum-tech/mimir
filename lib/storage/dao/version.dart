import 'package:version/version.dart';

abstract class VersionDao {
  Version? get lastVersion;
  set lastVersion(Version? newV);

  DateTime? get lastStartupTime;
  set lastStartupTime(DateTime? newV);
}
