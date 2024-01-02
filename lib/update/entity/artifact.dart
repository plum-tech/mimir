import 'package:json_annotation/json_annotation.dart';

part 'artifact.g.dart';

@JsonSerializable(createToJson: false)
class ArtifactVersionInfo {
  @JsonKey()
  final String version;
  @JsonKey(name: "release_time")
  final DateTime releaseTime;
  @JsonKey(name: "release_note")
  final String releaseNote;
  @JsonKey()
  final Map<String, ArtifactDownload> downloads;

  const ArtifactVersionInfo({
    required this.version,
    required this.releaseTime,
    required this.releaseNote,
    required this.downloads,
  });

  ArtifactDownload? get androidDownload => downloads["Android"];

  ArtifactDownload? get iOSDownload => downloads["iOS"];

  factory ArtifactVersionInfo.fromJson(Map<String, dynamic> json) => _$ArtifactVersionInfoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ArtifactDownload {
  @JsonKey()
  final String name;
  @JsonKey(name: "default")
  final String defaultUrlName;
  @JsonKey()
  final String sha256;
  @JsonKey()
  final Map<String, String> url;

  const ArtifactDownload({
    required this.name,
    required this.sha256,
    required this.defaultUrlName,
    required this.url,
  });

  String get defaultUrl => url[defaultUrlName]!;

  factory ArtifactDownload.fromJson(Map<String, dynamic> json) => _$ArtifactDownloadFromJson(json);
}
