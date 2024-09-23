import 'package:mimir/backend/update/entity/channel.dart';
import 'package:version/version.dart';

import '../entity/version.dart';
import 'update.dart';

class MimirUpdateServiceMock implements MimirUpdateService {
  MimirUpdateServiceMock();

  final version = Version.parse("3.0.0+500");

  @override
  Future<VersionInfo> getLatestVersionInfo({
    UpdateChannel channel = UpdateChannel.release,
  }) async {
    return VersionInfo(
      version: version,
      importance: ImportanceLevel.normal,
      minuteCanDelay: 7 * 24 * 60,
      time: DateTime.tryParse("2024-10-03T05:38:39.000Z"),
      releaseNote: const ReleaseNote(zhHans: "Test version"),
      assets: const VersionAssets(
        android: AndroidAssets(
          fileName: "sit-life.apk",
          defaultSrc: "https://www.mysit.life/download",
          src: {},
        ),
        iOS: IOSAssets(
          appStore: "https://apps.apple.com/cn/app/id6468989112",
          testFlight: "https://testflight.apple.com/join/hPeQ13fe",
        ),
      ),
    );
  }
}
