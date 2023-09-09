import 'package:flutter/material.dart';
import 'package:mimir/widgets/webview/page.dart';
import 'package:rettulf/rettulf.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../init.dart';
import '../using.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

final evaluationUri = Uri(
  scheme: 'http',
  host: 'jwxt.sit.edu.cn',
  path: '/jwglxt/xspjgl/xspj_cxXspjIndex.html',
  queryParameters: {
    'doType': 'details',
    'gnmkdm': 'N401605',
    'layout': 'default',
    // 'su': studentId,
  },
);

class _EvaluationPageState extends State<EvaluationPage> {
  final $autoScore = ValueNotifier(100);
  final controller = WebViewController();
  List<WebViewCookie>? cookies;

  @override
  void initState() {
    super.initState();
    $autoScore.addListener(setAllScores);
    loadCookies();
  }

  @override
  void dispose() {
    $autoScore.dispose();
    $autoScore.removeListener(setAllScores);
    super.dispose();
  }

  Future<void> setAllScores() async {
    await controller.runJavaScript(
      "for(const e of document.getElementsByClassName('input-pjf')) e.value='${$autoScore.value}'",
    );
  }

  Future<void> loadCookies() async {
    final cookies = await ExamResultInit.cookieJar.loadAsWebViewCookie(evaluationUri);
    setState(() {
      this.cookies = cookies;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cookies = this.cookies;
    if(cookies == null) return const SizedBox();
    return WebViewPage(
      controller: controller,
      initialUrl: evaluationUri.toString(),
      fixedTitle: i18n.teacherEvalTitle,
      initialCookies: cookies,
      bottomNavigationBar: BottomAppBar(
        child: $autoScore >>
            (context, value) => [
                  "Autofill Score：$value".text(),
                  Slider(
                    min: 0,
                    max: 100,
                    value: value.toDouble(),
                    onChanged: (v) => $autoScore.value = v.toInt(),
                  ).expanded(),
                ].row(),
      ),
    );
  }
}
