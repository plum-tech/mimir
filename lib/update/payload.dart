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
}

@JsonSerializable(createToJson: false)
class UpdateDownloadInfo {
  @JsonKey()
  final String name;
  @JsonKey()
  final String url;

  const UpdateDownloadInfo({
    required this.name,
    required this.url,
  });
}
