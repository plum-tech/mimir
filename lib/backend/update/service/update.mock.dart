import 'package:version/version.dart';

import '../entity/artifact.dart';
import 'update.dart';

class MimirUpdateServiceMock implements MimirUpdateService {
  MimirUpdateServiceMock();

  final version = Version.parse("3.0.0+500");

  @override
  Future<ArtifactVersionInfo> getLatestVersionFromOfficial() async {
    return ArtifactVersionInfo(
      version: version,
      releaseTime: DateTime.tryParse("2024-10-03T05:38:39.000Z"),
      releaseNote: "Test version",
      downloads: {
        "Android": const ArtifactDownload(
          name: "Test",
          sha256: "sha256",
          defaultUrlName: "default",
          name2Url: {"default": "mimir-test.apk"},
        ),
      },
    );
  }

  /// return null if the version from iTunes isn't identical to official's
  @override
  Future<ArtifactVersionInfo?> getLatestVersionFromAppStoreAndOfficial() async {
    return getLatestVersionFromOfficial();
  }

  @override
  Future<Version?> getLatestVersionFromAppStore({String? iosAppStoreRegion = "cn"}) async {
    return version;
  }
}
