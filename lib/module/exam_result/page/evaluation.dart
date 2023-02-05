import 'package:flutter/material.dart';

import '../init.dart';
import '../using.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final url = Uri(
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

  final _vn = ValueNotifier<int>(100);

  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _vn.addListener(() {
      _webViewController?.runJavascript(
        "for(const e of document.getElementsByClassName('input-pjf')) e.value='${_vn.value}'",
      );
    });
  }

  @override
  void dispose() {
    _vn.dispose();
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
              future: ExamResultInit.cookieJar.loadAsWebViewCookie(url),
              builder: (ctx, data, state) {
                if (data == null) return Placeholders.loading();
                return SimpleWebViewPage(
                  initialUrl: url.toString(),
                  fixedTitle: i18n.teacherEvalTitle,
                  initialCookies: data,
                  onWebViewCreated: (controller) => _webViewController = controller,
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _vn,
            builder: (context, value, child) {
              return Row(
                children: [
                  Text('填充分数：$value'),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: value.toDouble(),
                      onChanged: (v) => _vn.value = v.toInt(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
