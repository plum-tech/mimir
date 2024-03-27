import 'package:flutter/cupertino.dart';
import 'package:sit/utils/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _kClass2ndAutoRefresh = true;

class SchoolSettings {
  final Box box;

  SchoolSettings(this.box);

  late final class2nd = _Class2nd(box);
  late final examResult = _ExamResult(box);
  late final examArrange = _ExamArrange(box);

  static const ns = "/school";
}

class _Class2ndK {
  static const ns = "${SchoolSettings.ns}/class2nd";
  static const autoRefresh = "$ns/autoRefresh";
}

class _Class2nd {
  final Box box;

  const _Class2nd(this.box);

  bool get autoRefresh => box.safeGet(_Class2ndK.autoRefresh) ?? _kClass2ndAutoRefresh;

  set autoRefresh(bool newV) => box.safePut(_Class2ndK.autoRefresh, newV);
}

const _kExamResulShowResultPreview = true;

class _ExamResultK {
  static const ns = "${SchoolSettings.ns}/examResult";
  static const showResultPreview = "$ns/showResultPreview";
}

class _ExamResult {
  final Box box;

  _ExamResult(this.box);

  bool get showResultPreview => box.safeGet(_ExamResultK.showResultPreview) ?? _kExamResulShowResultPreview;

  set showResultPreview(bool newV) => box.safePut(_ExamResultK.showResultPreview, newV);

  Listenable listenShowResultPreview() => box.listenable(keys: [_ExamResultK.showResultPreview]);

  late final $showResultPreview = box.watchable<bool>(_ExamResultK.showResultPreview);
}

class _ExamArrangeK {
  static const ns = "${SchoolSettings.ns}/examArrange";
}

class _ExamArrange {
  final Box box;

  const _ExamArrange(this.box);
}
