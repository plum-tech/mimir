import 'package:hive/hive.dart';

const _kAutoUseImported = true;

class _K {
  static const ns = "/timetable";
  static const autoUseImported = "$ns/autoUseImported";
}

class TimetableSettings {
  final Box box;

  const TimetableSettings(this.box);

  bool get autoUseImported => box.get(_K.autoUseImported) ?? _kAutoUseImported;

  set autoUseImported(bool newV) => box.put(_K.autoUseImported, newV);
}
