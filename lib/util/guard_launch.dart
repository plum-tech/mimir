import 'package:mimir/app.dart';
import 'package:mimir/route.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> guardLaunchUrl(Uri url) async {
  if (url.scheme == "http" || url.scheme == "https") {
    // guards the http(s)
    if (!UniversalPlatform.isDesktopOrWeb) {
      $Key.currentState?.pushNamed(
        Routes.browser,
        arguments: {'initialUrl': url.toString()},
      );
      return true;
    }
    try {
      return await launchUrl(url);
    } catch (err) {
      return false;
    }
  }
  // not http(s)
  try {
    return await launchUrl(url);
  } catch (err) {
    return false;
  }
}

Future<bool> guardLaunchUrlString(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return await guardLaunchUrl(uri);
}
