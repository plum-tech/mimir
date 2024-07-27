import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/widgets/webview/page.dart';

class BbsPage extends StatefulWidget {
  const BbsPage({super.key});

  @override
  State<BbsPage> createState() => _BbsPageState();
}

class _BbsPageState extends State<BbsPage> {
  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      appBar: false,
      initialUrl: "https://bbs.mysit.life",
    ).safeArea();
  }
}
