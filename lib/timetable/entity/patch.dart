import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/utils/byte_io.dart';
import 'package:sit/utils/error.dart';

import '../widgets/patch/copy_day.dart';
import '../widgets/patch/move_day.dart';
import '../widgets/patch/remove_day.dart';
import '../widgets/patch/swap_days.dart';
import 'loc.dart';
import 'timetable.dart';
import '../i18n.dart';

part "patch.g.dart";

const _patchSetType = "patchSet";

sealed class TimetablePatchEntry {
  const TimetablePatchEntry();

  factory TimetablePatchEntry.fromJson(Map<String, dynamic> json) {
    final type = json["type"];
    if (type == _patchSetType) {
      return TimetablePatchSet.fromJson(json);
    } else {
      return TimetablePatch.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();

  String toDartCode();

  String encodeBase64() => _encodeBase64(this);

  Uint8List encodeByteList();

  static String _encodeBase64(TimetablePatchEntry obj) {
    final bytes = obj.encodeByteList();
    final encoded = base64Encode(bytes);
    return encoded;
  }
}

@JsonEnum(alwaysCreate: true)
enum TimetablePatchType {
  // addLesson,
  // removeLesson,
  // replaceLesson,
  // swapLesson,
  // moveLesson,
  // addDay,
  moveDay(TimetableMoveDayPatch.onCreate),
  removeDay(TimetableRemoveDayPatch.onCreate),
  copyDay(TimetableCopyDayPatch.onCreate),
  swapDays(TimetableSwapDaysPatch.onCreate),
  unknown(TimetableSwapDaysPatch.onCreate),
  ;

  static const creatable = [
    moveDay,
    removeDay,
    copyDay,
    swapDays,
  ];

  final FutureOr<TimetablePatch?> Function(BuildContext context, SitTimetable timetable) onCreate;

  const TimetablePatchType(this.onCreate);

  String l10n() => "timetable.patch.type.$name".tr();
}

/// To opt-in [JsonSerializable], please specify `toJson` parameter to [TimetablePatch.toJson].
sealed class TimetablePatch extends TimetablePatchEntry {
  @JsonKey()
  TimetablePatchType get type;

  const TimetablePatch();

  factory TimetablePatch.fromJson(Map<String, dynamic> json) {
    final type = $enumDecode(_$TimetablePatchTypeEnumMap, json["type"], unknownValue: TimetablePatchType.unknown);
    try {
      return switch (type) {
        // TimetablePatchType.addLesson => TimetableAddLessonPatch.fromJson(json),
        // TimetablePatchType.removeLesson => TimetableAddLessonPatch.fromJson(json),
        // TimetablePatchType.replaceLesson => TimetableAddLessonPatch.fromJson(json),
        // TimetablePatchType.swapLesson => TimetableAddLessonPatch.fromJson(json),
        // TimetablePatchType.moveLesson => TimetableAddLessonPatch.fromJson(json),
        // TimetablePatchType.addDay => TimetableAddLessonPatch.fromJson(json),
        TimetablePatchType.unknown => TimetableUnknownPatch.fromJson(json),
        TimetablePatchType.removeDay => TimetableRemoveDayPatch.fromJson(json),
        TimetablePatchType.swapDays => TimetableSwapDaysPatch.fromJson(json),
        TimetablePatchType.moveDay => TimetableMoveDayPatch.fromJson(json),
        TimetablePatchType.copyDay => TimetableCopyDayPatch.fromJson(json),
      };
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return const TimetableUnknownPatch();
    }
  }

  String l10n();
}

@JsonSerializable()
class TimetablePatchSet extends TimetablePatchEntry {
  final String name;
  final List<TimetablePatch> patches;

  const TimetablePatchSet({
    required this.name,
    required this.patches,
  });

  factory TimetablePatchSet.fromJson(Map<String, dynamic> json) => _$TimetablePatchSetFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimetablePatchSetToJson(this)..["type"] = _patchSetType;

  @override
  String toDartCode() {
    return 'TimetablePatchSet(name:"$name",patches:${patches.map((p) => p.toDartCode()).toList(growable: false)})';
  }

  @override
  Uint8List encodeByteList() => _encodeByteList(this);

  static Uint8List _encodeByteList(TimetablePatchSet obj) {
    final writer = ByteWriter(2048);
    writer.strUtf8(obj.name);
    writer.int8(max(obj.patches.length, 256));
    for (final patch in obj.patches) {
      writer.bytes(patch.encodeByteList());
    }
    return writer.build();
  }
}

class BuiltinTimetablePatchSet implements TimetablePatchSet {
  final String key;

  @override
  String get name => "timetable.patch.builtin.$key".tr();
  @override
  final List<TimetablePatch> patches;

  const BuiltinTimetablePatchSet({
    required this.key,
    required this.patches,
  });

  @override
  Uint8List encodeByteList() => TimetablePatchSet._encodeByteList(this);

  @override
  String encodeBase64() => TimetablePatchEntry._encodeBase64(this);

  @override
  Map<String, dynamic> toJson() => _$TimetablePatchSetToJson(this)..["type"] = _patchSetType;

  @override
  String toDartCode() {
    return 'BuiltinTimetablePatchSet(patches:${patches.map((p) => p.toDartCode()).toList(growable: false)})';
  }
}

//
// @JsonSerializable()
// class TimetableAddLessonPatch extends TimetablePatch {
//   @override
//   final type = TimetablePatchType.addLesson;
//
//   const TimetableAddLessonPatch();
//
//   factory TimetableAddLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableAddLessonPatchFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$TimetableAddLessonPatchToJson(this);
// }

// @JsonSerializable()
// class TimetableRemoveLessonPatch extends TimetablePatch {
//   @override
//   final type = TimetablePatchType.removeLesson;
//
//   const TimetableRemoveLessonPatch();
//
//   factory TimetableRemoveLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableRemoveLessonPatchFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$TimetableRemoveLessonPatchToJson(this);
// }
//
// @JsonSerializable()
// class TimetableMoveLessonPatch extends TimetablePatch {
//   @override
//   final type = TimetablePatchType.moveLesson;
//
//   const TimetableMoveLessonPatch();
//
//   factory TimetableMoveLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableMoveLessonPatchFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$TimetableMoveLessonPatchToJson(this);
// }

@JsonSerializable()
class TimetableUnknownPatch extends TimetablePatch {
  @JsonKey()
  @override
  TimetablePatchType get type => TimetablePatchType.unknown;

  final Map<String, dynamic>? legacy;

  const TimetableUnknownPatch({this.legacy});

  factory TimetableUnknownPatch.fromJson(Map<String, dynamic> json) {
    return TimetableUnknownPatch(legacy: json);
  }

  @override
  Uint8List encodeByteList() {
    final writer = ByteWriter(8);
    writer.int8(type.index);
    return writer.build();
  }

  @override
  Map<String, dynamic> toJson() => (legacy ?? {})..["type"] = _$TimetablePatchTypeEnumMap[type];

  @override
  String toDartCode() {
    return "TimetableUnknownPatch(legacy:$legacy)";
  }

  @override
  String l10n() {
    return i18n.unknown;
  }
}

@JsonSerializable()
class TimetableRemoveDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.removeDay;

  @JsonKey()
  final List<TimetableDayLoc> all;

  const TimetableRemoveDayPatch({
    required this.all,
  });

  TimetableRemoveDayPatch.oneDay({
    required TimetableDayLoc loc,
  }) : all = <TimetableDayLoc>[loc];

  factory TimetableRemoveDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableRemoveDayPatchFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimetableRemoveDayPatchToJson(this)..["type"] = _$TimetablePatchTypeEnumMap[type];

  @override
  Uint8List encodeByteList() {
    final writer = ByteWriter(512);
    writer.int8(type.index);
    writer.int8(max(all.length, 256));
    for (final loc in all) {
      writer.bytes(loc.encodeByteList());
    }
    return writer.build();
  }

  static Future<TimetableRemoveDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {
    final patch = await context.show$Sheet$(
      (ctx) => TimetableRemoveDayPatchSheet(
        timetable: timetable,
        patch: null,
      ),
    );
    return patch;
  }

  @override
  String toDartCode() {
    return "TimetableRemoveDayPatch(loc:${all.map((loc) => loc.toDartCode()).toList()})";
  }

  @override
  String l10n() {
    return i18n.patch.removeDay(all.map((loc) => loc.l10n()).join(", "));
  }
}

@JsonSerializable()
class TimetableMoveDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.moveDay;
  @JsonKey()
  final TimetableDayLoc source;
  @JsonKey()
  final TimetableDayLoc target;

  const TimetableMoveDayPatch({
    required this.source,
    required this.target,
  });

  @override
  Uint8List encodeByteList() {
    final writer = ByteWriter(32);
    writer.int8(type.index);
    writer.bytes(source.encodeByteList());
    writer.bytes(target.encodeByteList());
    return writer.build();
  }

  factory TimetableMoveDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableMoveDayPatchFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimetableMoveDayPatchToJson(this)..["type"] = _$TimetablePatchTypeEnumMap[type];

  static Future<TimetableMoveDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {
    final patch = await context.show$Sheet$(
      (ctx) => TimetableMoveDayPatchSheet(
        timetable: timetable,
        patch: null,
      ),
    );
    return patch;
  }

  @override
  String toDartCode() {
    return "TimetableMoveDayPatch(source:${source.toDartCode()},target:${target.toDartCode()},)";
  }

  @override
  String l10n() {
    return i18n.patch.moveDay(source.l10n(), target.l10n());
  }
}

@JsonSerializable()
class TimetableCopyDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.copyDay;
  @JsonKey()
  final TimetableDayLoc source;
  @JsonKey()
  final TimetableDayLoc target;

  const TimetableCopyDayPatch({
    required this.source,
    required this.target,
  });

  @override
  Uint8List encodeByteList() {
    final writer = ByteWriter(512);
    writer.int8(type.index);
    writer.bytes(source.encodeByteList());
    writer.bytes(target.encodeByteList());
    return writer.build();
  }

  factory TimetableCopyDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableCopyDayPatchFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimetableCopyDayPatchToJson(this)..["type"] = _$TimetablePatchTypeEnumMap[type];

  static Future<TimetableCopyDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {
    final patch = await context.show$Sheet$(
      (ctx) => TimetableCopyDayPatchSheet(
        timetable: timetable,
        patch: null,
      ),
    );
    return patch;
  }

  @override
  String l10n() {
    return i18n.patch.copyDay(source.l10n(), target.l10n());
  }

  @override
  String toDartCode() {
    return "TimetableCopyDayPatch(source:${source.toDartCode()},target:${target.toDartCode()})";
  }
}

@JsonSerializable()
class TimetableSwapDaysPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.swapDays;
  @JsonKey()
  final TimetableDayLoc a;
  @JsonKey()
  final TimetableDayLoc b;

  const TimetableSwapDaysPatch({
    required this.a,
    required this.b,
  });

  factory TimetableSwapDaysPatch.fromJson(Map<String, dynamic> json) => _$TimetableSwapDaysPatchFromJson(json);

  @override
  Uint8List encodeByteList() {
    final writer = ByteWriter(512);
    writer.int8(type.index);
    writer.bytes(a.encodeByteList());
    writer.bytes(b.encodeByteList());
    return writer.build();
  }

  @override
  Map<String, dynamic> toJson() => _$TimetableSwapDaysPatchToJson(this)..["type"] = _$TimetablePatchTypeEnumMap[type];

  static Future<TimetableSwapDaysPatch?> onCreate(BuildContext context, SitTimetable timetable) async {
    final patch = await context.show$Sheet$(
      (ctx) => TimetableSwapDaysPatchSheet(
        timetable: timetable,
        patch: null,
      ),
    );
    return patch;
  }

  @override
  String l10n() {
    return i18n.patch.swapDays(a.l10n(), b.l10n());
  }

  @override
  String toDartCode() {
    return "TimetableSwapDayPatch(a:${a.toDartCode()},b:${b.toDartCode()})";
  }
}
// factory .fromJson(Map<String, dynamic> json) => _$FromJson(json);
//
// Map<String, dynamic> toJson() => _$ToJson(this);
