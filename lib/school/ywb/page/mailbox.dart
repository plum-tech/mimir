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
  MyYwbApplications? applications;

  @override
  void initState() {
    super.initState();
    YwbInit.applicationService.getMyMessage().then((value) {
      debugPrint(value.toString());
    });
    // YwbInit.messageService.getAllMessage().then((value) {
    //   if (!mounted) return;
    //   setState(() {
    //     msgPage = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final applications = this.applications;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: i18n.mailbox.title.text(),
          bottom: applications != null
              ? null
              : const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                ),
        ),
        // if (applications != null)
        //   if (applications.msgList.isEmpty)
        //     SliverFillRemaining(
        //       child: LeavingBlank(
        //         icon: Icons.inbox_outlined,
        //         desc: i18n.mailbox.noMailsTip,
        //       ),
        //     )
        //   else
        //     SliverList.builder(
        //       itemCount: applications.msgList.length,
        //       itemBuilder: (ctx, i) => YwbMail(msg: applications.msgList[i]),
        //     ),
      ],
    );
  }
}
