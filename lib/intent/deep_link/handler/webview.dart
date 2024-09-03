import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebviewDeepLink implements DeepLinkHandlerProtocol {
  static const host = "webview";

  const WebviewDeepLink();

  @override
  bool match(Uri encoded) {
    return encoded.host == host && encoded.path.isEmpty;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  }) async {
    final target = data.path;
    if (target.isEmpty) return;
    if (kIsWeb || UniversalPlatform.isDesktop) {
      await launchUrlString(target, mode: LaunchMode.externalApplication);
    }
    final redirect = Uri(
      path: "/webview",
      queryParameters: {"url": target.toString()},
    ).toString();
    if (!context.mounted) return;
    await context.push(redirect);
  }
}
