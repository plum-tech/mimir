import 'package:hive/hive.dart';

const _kClass2ndAutoRefresh = true;

class SchoolSettings {
  final Box<dynamic> box;

  SchoolSettings(this.box);

  late final class2nd = _Class2nd(box);

  static const ns = "/school";
}

class _Class2ndK {
  static const ns = "${SchoolSettings.ns}/class2nd";
  static const autoRefresh = "$ns/autoRefresh";
}

class _Class2nd {
  final Box<dynamic> box;

  const _Class2nd(this.box);

  bool get autoRefresh => box.get(_Class2ndK.autoRefresh) ?? _kClass2ndAutoRefresh;

  set autoRefresh(bool foo) => box.put(_Class2ndK.autoRefresh, foo);
}
