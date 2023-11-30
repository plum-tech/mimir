import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sit/init.dart';

import 'package:sit/settings/settings.dart';
import 'package:sit/utils/cookies.dart';
import 'package:sit/widgets/webview/injectable.dart';
import 'package:sit/widgets/webview/page.dart';
import 'package:rettulf/rettulf.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../init.dart';
import '../i18n.dart';

class TeacherEvaluationPage extends StatefulWidget {
  const TeacherEvaluationPage({super.key});

  @override
  State<TeacherEvaluationPage> createState() => _TeacherEvaluationPageState();
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

const _skipCountingDownPageJs = """
onClickMenu.call(this, '/xspjgl/xspj_cxXspjIndex.html?doType=details', 'N401605', { "offDetails": "1" })
""";

class _TeacherEvaluationPageState extends State<TeacherEvaluationPage> {
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
    // refresh the cookies
    await ExamResultInit.service.session.request(
      evaluationUri.toString(),
      options: Options(
        method: "GET",
      ),
    );
    final cookies = await Init.cookieJar.loadAsWebViewCookie(evaluationUri);
    setState(() {
      this.cookies = cookies;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cookies = this.cookies;
    if (cookies == null) return const SizedBox();
    return WebViewPage(
      controller: controller,
      initialUrl: evaluationUri.toString(),
      fixedTitle: i18n.teacherEvalTitle,
      initialCookies: cookies,
      pageFinishedInjections: const [
        Injection(
          js: _skipCountingDownPageJs,
        ),
      ],
      bottomNavigationBar: Settings.isDeveloperMode
          ? BottomAppBar(
              height: 40,
              child: buildAutofillScore(),
            )
          : null,
    );
  }

  Widget buildAutofillScore() {
    return $autoScore >>
        (context, value) => Slider(
              min: 0,
              max: 100,
              divisions: 100,
              label: value.toString(),
              value: value.toDouble(),
              onChanged: (v) => $autoScore.value = v.toInt(),
            );
  }
}
