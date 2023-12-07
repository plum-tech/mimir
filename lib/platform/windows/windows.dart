import 'win32_web_mock.dart' if (dart.library.io) 'win32.dart';

class WindowsInit {
  static Future<void> registerCustomScheme(String scheme) async {
    await registerCustomSchemeWin32(scheme);
  }
}
