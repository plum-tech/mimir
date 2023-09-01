import 'package:flutter/material.dart';

import '../entity/message.dart';
import '../page/browser.dart';
import '../using.dart';

class Mail extends StatelessWidget {
  final ApplicationMsg msg;

  const Mail({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(msg.name),
      subtitle: Text('${i18n.mailbox.recent}: ${msg.recentStep}'),
      trailing: Text(msg.status),
      onTap: () {
        // 跳转到详情页面
        final String resultUrl =
            'https://xgfy.sit.edu.cn/unifri-flow/WF/mobile/index.html?ismobile=1&FK_Flow=${msg.functionId}&WorkID=${msg.flowId}&IsReadonly=1&IsView=1';
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => InAppViewPage(title: msg.name, url: resultUrl)));
      },
    );
  }
}
