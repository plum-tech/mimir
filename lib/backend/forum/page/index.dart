import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/widgets/inapp_webview/page.dart';

class MimirForumPage extends StatefulWidget {
  const MimirForumPage({super.key});

  @override
  State<MimirForumPage> createState() => _MimirForumPageState();
}

class _MimirForumPageState extends State<MimirForumPage> {
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
