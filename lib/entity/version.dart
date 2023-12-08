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
  final Version full;

  const AppVersion({
    required this.platform,
    required this.full,
  });
}

Future<AppVersion> getCurrentVersion() async {
  final info = await PackageInfo.fromPlatform();
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
  return AppVersion(platform: platform, full: Version.parse(info.version));
}
