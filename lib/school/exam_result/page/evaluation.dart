import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/init.dart';

import 'package:mimir/settings/dev.dart';
import 'package:mimir/utils/cookies.dart';
import 'package:mimir/widget/webview/injectable.dart';
import 'package:mimir/widget/webview/page.dart';
import 'package:rettulf/rettulf.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../i18n.dart';

final teacherEvaluationUri = Uri(
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

class TeacherEvaluationPage extends ConsumerStatefulWidget {
  const TeacherEvaluationPage({super.key});

  @override
  ConsumerState<TeacherEvaluationPage> createState() => _TeacherEvaluationPageState();
}

class _TeacherEvaluationPageState extends ConsumerState<TeacherEvaluationPage> {
  final $autoScore = ValueNotifier(100);
  final controller = WebViewController();
  var submitEnabled = true;
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

  Future<void> submit() async {
    await controller.runJavaScript(
      "document.getElementById('btn_xspj_tj')?.click()",
    );
  }

  Future<void> checkSubmitEnabled() async {
    final enabled = await controller.runJavaScriptReturningResult(
      "Boolean(document.getElementById('btn_xspj_tj'))",
    );
    setState(() {
      submitEnabled = enabled == true;
    });
  }

  Future<void> loadCookies() async {
    // refresh the cookies
    await Init.ugRegSession.request(teacherEvaluationUri.toString());
    final cookies = await Init.schoolCookieJar.loadAsWebViewCookie(teacherEvaluationUri);
    setState(() {
      this.cookies = cookies;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cookies = this.cookies;
    if (cookies == null) {
      return Scaffold(
        appBar: AppBar(
          title: i18n.teacherEvalTitle.text(),
        ),
        body: const CircularProgressIndicator.adaptive().center(),
      );
    }
    return WebViewPage(
      controller: controller,
      initialUrl: teacherEvaluationUri.toString(),
      fixedTitle: i18n.teacherEvalTitle,
      initialCookies: cookies,
      pageFinishedInjections: const [
        Injection(
          js: _skipCountingDownPageJs,
        ),
      ],
      bottomNavigationBar: ref.watch(Dev.$on) ? buildAdvancedBottomBar() : null,
    );
  }

  Widget buildAdvancedBottomBar() {
    return BottomAppBar(
      height: 55,
      child: [
        buildAutofillScore().expanded(),
        PlatformTextButton(
          onPressed: submitEnabled
              ? () async {
                  await setAllScores();
                  await submit();
                }
              : null,
          child: i18n.submit.text(),
        ),
      ].row(),
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
