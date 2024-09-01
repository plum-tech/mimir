import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewDeepLink implements DeepLinkHandlerProtocol {
  static const host = "webview";

  const WebviewDeepLink();

  Uri? decode(Uri data) {
    final params = data.queryParameters;
    final target = params.entries.firstWhereOrNull((p) => p.value.isEmpty)?.key;
    if (target == null) return null;
    return Uri.tryParse(target);
  }

  @override
  bool match(Uri encoded) {
    return encoded.host == host && encoded.path.isEmpty;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  }) async {
    final target = decode(data);
    if (target == null) return;
    if (kIsWeb || UniversalPlatform.isDesktop) {
      await launchUrl(target, mode: LaunchMode.externalApplication);
    }
    final redirect = Uri(
      path: "/browser",
      queryParameters: {"url": target.toString()},
    ).toString();
    if (!context.mounted) return;
    await context.push(redirect);
  }
}
