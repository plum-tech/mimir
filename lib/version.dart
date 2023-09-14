import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

enum AppPlatform {
  android("Android"),
  windows("Windows"),
  iOS("iOS"),
  macOS("macOS"),
  linux("Linux"),
  web("Web"),
  unknown("?");

  final String name;
  const AppPlatform(this.name);
}

class AppVersion {
  final AppPlatform platform;
  final String version;
  final Version? full;

  const AppVersion(this.platform, this.version, {this.full});
}

Future<AppVersion> getCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final AppPlatform platform;
  if (UniversalPlatform.isAndroid) {
    platform = AppPlatform.android;
  } else if (UniversalPlatform.isIOS) {
    platform = AppPlatform.iOS;
  } else if (UniversalPlatform.isMacOS) {
    platform = AppPlatform.macOS;
  } else if (UniversalPlatform.isLinux) {
    platform = AppPlatform.linux;
  } else if (UniversalPlatform.isWindows) {
    platform = AppPlatform.windows;
  } else if (UniversalPlatform.isWeb) {
    platform = AppPlatform.web;
  } else {
    platform = AppPlatform.unknown;
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
