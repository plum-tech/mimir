import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _kClass2ndAutoRefresh = true;

class SchoolSettings {
  final Box<dynamic> box;

  SchoolSettings(this.box);

  late final class2nd = _Class2nd(box);
  late final examResult = _ExamResult(box);

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

  set autoRefresh(bool newV) => box.put(_Class2ndK.autoRefresh, newV);
}

const _kExamResulAppCardShowResultDetails = false;

class _ExamResultK {
  static const ns = "${SchoolSettings.ns}/examResult";
  static const appCardShowResultDetails = "$ns/appCardShowResultDetails";
}

class _ExamResult {
  final Box<dynamic> box;

  const _ExamResult(this.box);

  bool get appCardShowResultDetails =>
      box.get(_ExamResultK.appCardShowResultDetails) ?? _kExamResulAppCardShowResultDetails;

  set appCardShowResultDetails(bool newV) => box.put(_ExamResultK.appCardShowResultDetails, newV);

  ValueListenable<Box> listenAppCardShowResultDetails() =>
      box.listenable(keys: [_ExamResultK.appCardShowResultDetails]);
}
