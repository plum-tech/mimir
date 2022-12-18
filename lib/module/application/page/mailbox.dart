import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

import '../entity/message.dart';
import '../init.dart';
import '../user_widget/mail.dart';
import '../using.dart';

class Mailbox extends StatefulWidget {
  const Mailbox({super.key});

  @override
  State<Mailbox> createState() => _MailboxState();
}

class _MailboxState extends State<Mailbox> {
  ApplicationMsgPage? _msgPage;

  @override
  void initState() {
    super.initState();
    ApplicationInit.messageService.getAllMessage().then((value) {
      if (!mounted) return;
      setState(() {
        _msgPage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final msg = _msgPage;

    if (msg == null) {
      return Placeholders.loading();
    } else {
      if (msg.msgList.isNotEmpty) {
        return _buildMessageList(context, msg.msgList);
      } else {
        return LeavingBlank(icon: Icons.upcoming_outlined, desc: i18n.applicationMailboxEmptyTip);
      }
    }
  }

  Widget _buildMessageList(BuildContext context, List<ApplicationMsg> list) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final count = constraints.maxWidth ~/ 300;
      return LiveGrid.options(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
        ),
        options: kiteLiveOptions,
        itemBuilder: (ctx, index, animation) => Mail(msg: list[index]).aliveWith(animation),
      );
    });
  }
}
