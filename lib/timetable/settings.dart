import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/utils/json.dart';

import 'p13n/entity/background.dart';
import 'p13n/entity/cell_style.dart';

const _kAutoUseImported = true;
const _kQuickLookCourseOnTap = true;

class _K {
  static const ns = "/timetable";
  static const autoUseImported = "$ns/autoUseImported";
  static const backgroundImage = "$ns/backgroundImage";
  static const cellStyle = "$ns/cellStyle";
  static const quickLookLessonOnTap = "$ns/quickLookLessonOnTap";
}

class TimetableSettings {
  final Box box;

  TimetableSettings(this.box);

  bool get autoUseImported => box.safeGet<bool>(_K.autoUseImported) ?? _kAutoUseImported;

  set autoUseImported(bool newV) => box.safePut<bool>(_K.autoUseImported, newV);

  late final $autoUseImported = box.provider<bool>(_K.autoUseImported);

  CourseCellStyle? get cellStyle => decodeJsonObject(
        box.safeGet<String>(_K.cellStyle),
        (obj) => CourseCellStyle.fromJson(obj),
      );

  set cellStyle(CourseCellStyle? newV) => box.safePut<String>(
        _K.cellStyle,
        encodeJsonObject(newV, (obj) => obj.toJson()),
      );

  late final $cellStyle = box.provider(
    _K.cellStyle,
    get: () => cellStyle,
    set: (v) => cellStyle = v,
  );

  ValueListenable listenCellStyle() => box.listenable(keys: [_K.cellStyle]);

  BackgroundImage? get backgroundImage => decodeJsonObject(
        box.safeGet<String>(_K.backgroundImage),
        (obj) => BackgroundImage.fromJson(obj),
      );

  set backgroundImage(BackgroundImage? newV) => box.safePut<String>(
        _K.backgroundImage,
        jsonEncode(newV?.toJson()),
      );

  late final $backgroundImage = box.provider(
    _K.backgroundImage,
    get: () => backgroundImage,
    set: (v) => backgroundImage = v,
  );

  ValueListenable listenBackgroundImage() => box.listenable(keys: [_K.backgroundImage]);

  bool get quickLookLessonOnTap => box.safeGet<bool>(_K.quickLookLessonOnTap) ?? _kQuickLookCourseOnTap;

  set quickLookLessonOnTap(bool newV) => box.safePut<bool>(_K.quickLookLessonOnTap, newV);

  late final $quickLookLessonOnTap = box.provider<bool>(_K.quickLookLessonOnTap);
}
