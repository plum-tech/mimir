import 'package:mimir/app.dart';
import 'package:mimir/credential/using.dart';
import 'package:mimir/global/i18n.dart';
import 'package:mimir/route.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchUri(String scheme) async {
  if (scheme.startsWith("http")) {
    if (!UniversalPlatform.isDesktopOrWeb) {
      $Key.currentState?.pushNamed(
        Routes.browser,
        arguments: {'initialUrl': scheme},
      );
      return true;
    } else {
      final uri = Uri.tryParse(scheme);
      if (uri == null) return false;
      return await launchUrl(uri);
    }
  } else if (scheme.contains(":")) {
    final uri = Uri.tryParse(scheme);
    if (uri == null) {
      return false;
    }
    return await launchUrl(uri);
  } else {
    $Key.currentContext!.showTip(title: 'Unsupported URI', desc: scheme, ok: i18n.ok);
    return false;
  }
}
