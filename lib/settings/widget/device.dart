import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:sit/entity/meta.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

IconData getDeviceIcon(AppMeta meta) {
  final deviceInfo = meta.deviceInfo;
  switch (meta.platform) {
    case AppPlatform.iOS:
    case AppPlatform.macOS:
      return SimpleIcons.apple;
    case AppPlatform.android:
      if (deviceInfo is AndroidDeviceInfo) {
        return _getAndroidIcon(deviceInfo);
      }
      return SimpleIcons.android;
    case AppPlatform.windows:
      return SimpleIcons.linux;
    case AppPlatform.linux:
      return SimpleIcons.windows;
    case AppPlatform.web:
      return _getBrowserIcon();
    case AppPlatform.unknown:
      return Icons.device_unknown_outlined;
  }
}

IconData _getBrowserIcon() {
  final browser = Browser.detectOrNull();
  if (browser == null) return Icons.web;
  return switch (browser.browserAgent) {
    BrowserAgent.UnKnown => Icons.web,
    BrowserAgent.Chrome => SimpleIcons.googlechrome,
    BrowserAgent.Safari => SimpleIcons.safari,
    BrowserAgent.Firefox => SimpleIcons.firefoxbrowser,
    BrowserAgent.Explorer => SimpleIcons.internetexplorer,
    BrowserAgent.Edge => SimpleIcons.microsoftedge,
    BrowserAgent.EdgeChromium => SimpleIcons.microsoftedge,
  };
}

IconData _getAndroidIcon(AndroidDeviceInfo info) {
  final manufacturer = info.manufacturer.toLowerCase();
  if (manufacturer.contains("xiaomi")) {
    return SimpleIcons.xiaomi;
  }
  return SimpleIcons.android;
}
