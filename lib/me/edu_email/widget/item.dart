import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/email.dart';

class EmailPreviewWidget extends StatelessWidget {
  final MailEntity mail;

  const EmailPreviewWidget(this.mail, {super.key});

  @override
  Widget build(BuildContext context) {
    final subtitleColor = context.colorScheme.onSurfaceVariant;
    final date = mail.formatDate(context);
    return [
      [
        mail.senders.first.displayName.text(
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        [
          if (date != null) date.text(style: context.textTheme.labelMedium?.copyWith(color: subtitleColor)),
          Icon(
            context.icons.rightChevron,
            color: subtitleColor,
          ),
        ].row(),
      ].row(maa: MainAxisAlignment.spaceBetween),
      mail.subject.text(style: context.textTheme.titleMedium),
      mail.plaintext.substring(0, min(300, mail.plaintext.length)).text(
            style: context.textTheme.labelMedium?.copyWith(color: subtitleColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
    ].column(caa: CrossAxisAlignment.start);
  }
}
