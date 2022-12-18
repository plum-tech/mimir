import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

class AppVersion {
  String platform;
  String version;
  Version? full;

  AppVersion(this.platform, this.version, {this.full});
}

Future<AppVersion> getCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final String platform;
  if (UniversalPlatform.isAndroid) {
    platform = "Android";
  } else if (UniversalPlatform.isIOS) {
    platform = "iOS";
  } else if (UniversalPlatform.isMacOS) {
    platform = "macOS";
  } else if (UniversalPlatform.isLinux) {
    platform = "Linux";
  } else if (UniversalPlatform.isWindows) {
    platform = "Windows";
  } else if (UniversalPlatform.isWeb) {
    platform = "Web";
  } else {
    platform = "Unknown";
  }
  return AppVersion(platform, packageInfo.version, full: packageInfo.tryParseVersion());
}

extension PackageInfoEx on PackageInfo {
  Version? tryParseVersion() {
    try {
      final res = Version.parse(version);
      return Version(res.major, res.minor, res.patch, build: buildNumber);
    } catch (_) {
      return null;
    }
  }
}
