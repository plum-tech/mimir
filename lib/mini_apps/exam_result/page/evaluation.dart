import 'package:flutter/material.dart';
import 'package:mimir/widgets/placeholder_future_builder.dart';
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

  @override
  void initState() {
    super.initState();
    $autoScore.addListener(() {
      controller.runJavaScript(
        "for(const e of document.getElementsByClassName('input-pjf')) e.value='${$autoScore.value}'",
      );
    });
  }

  @override
  void dispose() {
    $autoScore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: PlaceholderFutureBuilder<List<WebViewCookie>>(
              future: ExamResultInit.cookieJar.loadAsWebViewCookie(evaluationUri),
              builder: (ctx, data, state) {
                if (data == null) return const CircularProgressIndicator();
                return WebViewPage(
                  controller: controller,
                  initialUrl: evaluationUri.toString(),
                  fixedTitle: i18n.teacherEvalTitle,
                  initialCookies: data,
                );
              },
            ),
          ),
          $autoScore >>
              (context, value) => [
                    "Autofill Score：$value".text(),
                    Slider(
                      min: 0,
                      max: 100,
                      value: value.toDouble(),
                      onChanged: (v) => $autoScore.value = v.toInt(),
                    ).expanded(),
                  ].row(),
        ],
      ),
    );
  }
}
