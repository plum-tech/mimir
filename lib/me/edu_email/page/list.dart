import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

import '../widgets/item.dart';

class EduEmailList extends StatefulWidget {
  final List<MimeMessage> messages;

  const EduEmailList({super.key, required this.messages});

  @override
  State<EduEmailList> createState() => _EduEmailListState();
}

class _EduEmailListState extends State<EduEmailList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.messages.length,
      itemBuilder: (ctx, i) {
        return EmailItem(widget.messages[i]);
      },
      separatorBuilder: (ctx, i) {
        return const VerticalDivider();
      },
    );
  }
}
