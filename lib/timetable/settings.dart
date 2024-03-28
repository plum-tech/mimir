import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/timetable/entity/background.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/utils/json.dart';

import 'entity/cell_style.dart';

const _kAutoUseImported = true;

class _K {
  static const ns = "/timetable";
  static const autoUseImported = "$ns/autoUseImported";
  static const backgroundImage = "$ns/backgroundImage";
  static const cellStyle = "$ns/cellStyle";
}

class TimetableSettings {
  final Box box;

  TimetableSettings(this.box);

  bool get autoUseImported => box.safeGet(_K.autoUseImported) ?? _kAutoUseImported;

  set autoUseImported(bool newV) => box.safePut(_K.autoUseImported, newV);

  CourseCellStyle? get cellStyle =>
      decodeJsonObject(box.safeGet<String>(_K.cellStyle), (obj) => CourseCellStyle.fromJson(obj));

  set cellStyle(CourseCellStyle? newV) => box.safePut(_K.cellStyle, encodeJsonObject(newV, (obj) => obj.toJson()));

  ValueListenable listenCellStyle() => box.listenable(keys: [_K.cellStyle]);

  BackgroundImage? get backgroundImage =>
      decodeJsonObject(box.safeGet<String>(_K.backgroundImage), (obj) => BackgroundImage.fromJson(obj));

  set backgroundImage(BackgroundImage? newV) => box.safePut(_K.backgroundImage, jsonEncode(newV?.toJson()));

  ValueListenable listenBackgroundImage() => box.listenable(keys: [_K.backgroundImage]);
}
