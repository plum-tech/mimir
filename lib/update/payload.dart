import 'package:json_annotation/json_annotation.dart';

part 'payload.g.dart';

@JsonSerializable(createToJson: false)
class UpdateInfoPayload {
  @JsonKey()
  final String version;
  @JsonKey(name: "release_time")
  final DateTime releaseTime;
  @JsonKey(name: "release_note")
  final String releaseNote;
  @JsonKey()
  final Map<String, UpdateDownloadInfo> downloads;

  const UpdateInfoPayload({
    required this.version,
    required this.releaseTime,
    required this.releaseNote,
    required this.downloads,
  });

  UpdateDownloadInfo? get androidDownload => downloads["Android"];

  UpdateDownloadInfo? get iOSDownload => downloads["iOS"];
}

@JsonSerializable(createToJson: false)
class UpdateDownloadInfo {
  @JsonKey()
  final String name;
  @JsonKey(name: "default")
  final String defaultUrlName;
  @JsonKey()
  final String sha256;
  @JsonKey()
  final Map<String, String> url;

  const UpdateDownloadInfo({
    required this.name,
    required this.sha256,
    required this.defaultUrlName,
    required this.url,
  });

  String get defaultUrl => url[defaultUrlName]!;
}
