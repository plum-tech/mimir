import 'dart:io';

import 'package:universal_platform/universal_platform.dart';
import 'package:win32_registry/win32_registry.dart';

class WindowsInit {
  static Future<void> registerCustomScheme(String scheme) async {
    if (!UniversalPlatform.isWindows) return;
    final appPath = Platform.resolvedExecutable;

    final protocolRegKey = 'Software\\Classes\\$scheme';
    const protocolRegValue = RegistryValue(
      'URL Protocol',
      RegistryValueType.string,
      '',
    );
    const protocolCmdRegKey = 'shell\\open\\command';
    final protocolCmdRegValue = RegistryValue(
      '',
      RegistryValueType.string,
      '"$appPath" "%1"',
    );

    final regKey = Registry.currentUser.createKey(protocolRegKey);
    regKey.createValue(protocolRegValue);
    regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
  }
}
