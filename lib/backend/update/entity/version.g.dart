// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseNote _$ReleaseNoteFromJson(Map<String, dynamic> json) => ReleaseNote(
      zhHans: json['zh-Hans'] as String,
      en: json['en'] as String?,
    );

AndroidAssets _$AndroidAssetsFromJson(Map<String, dynamic> json) => AndroidAssets(
      fileName: json['fileName'] as String,
      defaultSrc: json['defaultSrc'] as String?,
      src: Map<String, String?>.from(json['src'] as Map),
    );

IOSAssets _$IOSAssetsFromJson(Map<String, dynamic> json) => IOSAssets(
      appStore: json['appStore'] as String?,
      testFlight: json['testFlight'] as String?,
    );

VersionAssets _$VersionAssetsFromJson(Map<String, dynamic> json) => VersionAssets(
      android: AndroidAssets.fromJson(json['Android'] as Map<String, dynamic>),
      iOS: IOSAssets.fromJson(json['iOS'] as Map<String, dynamic>),
    );

VersionInfo _$VersionInfoFromJson(Map<String, dynamic> json) => VersionInfo(
      version: Version.parse(json['version'] as String),
      time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
      releaseNote: ReleaseNote.fromJson(json['releaseNote'] as Map<String, dynamic>),
      importance: $enumDecode(_$ImportanceLevelEnumMap, json['importance']),
      minuteCanDelay: (json['minuteCanDelay'] as num).toInt(),
      assets: VersionAssets.fromJson(json['assets'] as Map<String, dynamic>),
    );

const _$ImportanceLevelEnumMap = {
  ImportanceLevel.critical: 'critical',
  ImportanceLevel.high: 'high',
  ImportanceLevel.normal: 'normal',
  ImportanceLevel.low: 'low',
};
