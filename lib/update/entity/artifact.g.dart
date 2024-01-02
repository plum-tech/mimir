// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtifactVersionInfo _$ArtifactVersionInfoFromJson(Map<String, dynamic> json) => ArtifactVersionInfo(
      version: Version.parse(json['version'] as String),
      releaseTime: DateTime.parse(json['release_time'] as String),
      releaseNote: json['release_note'] as String,
      downloads: (json['downloads'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, ArtifactDownload.fromJson(e as Map<String, dynamic>)),
      ),
    );

ArtifactDownload _$ArtifactDownloadFromJson(Map<String, dynamic> json) => ArtifactDownload(
      name: json['name'] as String,
      sha256: json['sha256'] as String,
      defaultUrlName: json['default'] as String,
      name2Url: Map<String, String>.from(json['url'] as Map),
    );
