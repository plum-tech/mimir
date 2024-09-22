import 'package:json_annotation/json_annotation.dart';
import 'package:version/version.dart';

part 'version.g.dart';

@JsonEnum()
enum ImportanceLevel {
  critical,
  high,
  normal,
  low,
}

@JsonSerializable(createToJson: false)
class ReleaseNote {
  @JsonKey(name: "zh-Hans")
  final String zhHans;
  @JsonKey(name: "en")
  final String? en;

  const ReleaseNote({
    required this.zhHans,
    required this.en,
  });

  factory ReleaseNote.fromJson(Map<String, dynamic> json) => _$ReleaseNoteFromJson(json);
}

@JsonSerializable(createToJson: false)
class AndroidAssets {
  final String fileName;
  final String defaultSrc;
  final Map<String, String?> src;

  const AndroidAssets({
    required this.fileName,
    required this.defaultSrc,
    required this.src,
  });

  factory AndroidAssets.fromJson(Map<String, dynamic> json) => _$AndroidAssetsFromJson(json);
}

@JsonSerializable(createToJson: false)
class IOSAssets {
  final String? appStore;
  final String? testFlight;

  const IOSAssets({
    required this.appStore,
    required this.testFlight,
  });

  factory IOSAssets.fromJson(Map<String, dynamic> json) => _$IOSAssetsFromJson(json);
}

@JsonSerializable(createToJson: false)
class VersionAssets {
  @JsonKey(name: "Android")
  final AndroidAssets android;
  @JsonKey(name: "iOS")
  final IOSAssets iOS;

  const VersionAssets({
    required this.android,
    required this.iOS,
  });

  factory VersionAssets.fromJson(Map<String, dynamic> json) => _$VersionAssetsFromJson(json);
}

@JsonSerializable(createToJson: false)
class VersionInfo {
  @JsonKey(fromJson: Version.parse)
  final Version version;
  final DateTime? time;
  final ImportanceLevel importance;
  final int delayInMinute;
  final ReleaseNote releaseNote;
  final VersionAssets assets;

  const VersionInfo({
    required this.version,
    required this.time,
    required this.releaseNote,
    required this.importance,
    required this.delayInMinute,
    required this.assets,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) => _$VersionInfoFromJson(json);

  @override
  String toString() {
    return version.toString();
  }
}
