import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/message.dart';
import '../init.dart';
import '../widgets/mail.dart';
import '../i18n.dart';

class YwbMailboxPage extends StatefulWidget {
  const YwbMailboxPage({super.key});

  @override
  State<YwbMailboxPage> createState() => _YwbMailboxPageState();
}

class _YwbMailboxPageState extends State<YwbMailboxPage> {
  ApplicationMessagePage? msgPage;

  @override
  void initState() {
    super.initState();
    YwbInit.messageService.getAllMessage().then((value) {
      if (!mounted) return;
      setState(() {
        msgPage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final msgPage = this.msgPage;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: i18n.mailbox.title.text(),
          bottom: msgPage != null
              ? null
              : const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                ),
        ),
        if (msgPage != null)
          if (msgPage.msgList.isEmpty)
            SliverToBoxAdapter(
              child: LeavingBlank(
                icon: Icons.inbox_outlined,
                desc: i18n.mailbox.noMailsTip,
              ),
            )
          else
            SliverList.builder(
              itemCount: msgPage.msgList.length,
              itemBuilder: (ctx, i) => YwbMail(msg: msgPage.msgList[i]),
            ),
      ],
    );
  }
}
