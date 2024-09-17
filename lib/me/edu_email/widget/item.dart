import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';

import '../page/details.dart';

// TODO: Migration
class EmailItem extends StatelessWidget {
  final MimeMessage _message;

  const EmailItem(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium;

    final subjectText = _message.decodeSubject() ?? '';
    final sender = _message.decodeSender();
    final senderText = sender[0].toString() + (sender.length > 1 ? '...' : '');
    final date = _message.decodeDate();
    final dateText = date != null ? context.formatYmdNum(date) : '';

    return ListTile(
      title: Text(subjectText, style: titleStyle, maxLines: 1, overflow: TextOverflow.fade),
      subtitle: Text(senderText, style: subtitleStyle),
      trailing: Text(dateText, style: subtitleStyle),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => EduEmailDetailsPage(_message)));
      },
    );
  }
}
