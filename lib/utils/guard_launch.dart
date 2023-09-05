import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> guardLaunchUrl(BuildContext ctx, Uri url) async {
  if (url.scheme == "http" || url.scheme == "https") {
    // guards the http(s)
    if (!UniversalPlatform.isDesktopOrWeb) {
      ctx.push("/browser", extra: url.toString());
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

Future<bool> guardLaunchUrlString(BuildContext ctx, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return await guardLaunchUrl(ctx, uri);
}
