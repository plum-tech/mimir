import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/widgets/inapp_webview/page.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    return InAppWebViewPage(
      enableShare: false,
      enableOpenInBrowser: false,
      initialUri: WebUri.uri(R.forumUri),
      canNavigate: limitOrigin(R.forumUri, onBlock: (uri) async {
        await guardLaunchUrl(context, uri);
      }),
    );
  }
}
