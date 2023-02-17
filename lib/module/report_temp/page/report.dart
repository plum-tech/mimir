import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../using.dart';

const _reportUrlPrefix = 'http://xgfy.sit.edu.cn/h5/#/';
const _reportUrlIndex = '${_reportUrlPrefix}pages/index/index';

class DailyReportPage extends StatelessWidget {
  final OACredential oaCredential;

  const DailyReportPage({super.key, required this.oaCredential});

  Future<String> _getInjectJs() async {
    // TODO: 把 replace 完的 JS 缓存了
    final String username = oaCredential.account;
    final String css = await rootBundle.loadString('assets/report_temp/inject.css');
    final String js = await rootBundle.loadString('assets/report_temp/inject.js');
    return js.replaceFirst('{{username}}', username).replaceFirst('{{injectCSS}}', css);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: _reportUrlIndex,
      fixedTitle: MiniApp.reportTemp.l10nName(),
      injectJsRules: [
        InjectJsRuleItem(
          rule: FunctionalRule((url) => url.startsWith(_reportUrlPrefix)),
          asyncJavascript: _getInjectJs(),
        ),
      ],
    );
  }
}
