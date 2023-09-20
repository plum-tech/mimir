import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

import 'item.dart';

class EduEmailList extends StatelessWidget {
  final List<MimeMessage> messages;

  const EduEmailList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: messages.length,
      itemBuilder: (ctx, i) {
        return EmailItem(messages[i]);
      },
      separatorBuilder: (ctx, i) {
        return const VerticalDivider();
      },
    );
  }
}
