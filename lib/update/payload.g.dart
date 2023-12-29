// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInfoPayload _$UpdateInfoPayloadFromJson(Map<String, dynamic> json) => UpdateInfoPayload(
      version: json['version'] as String,
      releaseTime: DateTime.parse(json['release_time'] as String),
      releaseNote: json['release_note'] as String,
      downloads: (json['downloads'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, UpdateDownloadInfo.fromJson(e as Map<String, dynamic>)),
      ),
    );

UpdateDownloadInfo _$UpdateDownloadInfoFromJson(Map<String, dynamic> json) => UpdateDownloadInfo(
      name: json['name'] as String,
      url: json['url'] as String,
    );
