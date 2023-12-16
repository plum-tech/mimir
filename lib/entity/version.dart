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

class AppMeta {
  final AppPlatform platform;
  final Version version;

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The build signature. Empty string on iOS, signing key signature (hex) on Android.
  final String buildSignature;

  /// The installer store. Indicates through which store this application was installed.
  final String? installerStore;

  const AppMeta({
    required this.platform,
    required this.version,
    required this.appName,
    required this.packageName,
    required this.buildSignature,
    required this.installerStore,
  });
}

Future<AppMeta> getCurrentVersion() async {
  final info = await PackageInfo.fromPlatform();
  var versionText = info.version;
  if (info.buildNumber.isNotEmpty) {
    if (UniversalPlatform.isIOS && info.buildNumber != info.version) {
      // do nothing
    } else {
      versionText = "${info.version}+${info.buildNumber}";
    }
  }

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
  return AppMeta(
    platform: platform,
    version: Version.parse(versionText),
    appName: info.appName,
    packageName: info.packageName,
    buildSignature: info.buildSignature,
    installerStore: info.installerStore,
  );
}
