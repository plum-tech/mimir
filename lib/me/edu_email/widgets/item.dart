import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';

import '../page/detail.dart';

class EmailItem extends StatelessWidget {
  final MimeMessage _message;

  const EmailItem(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.subtitle1;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;

    final subjectText = _message.decodeSubject() ?? '无主题';
    final sender = _message.decodeSender();
    final senderText = sender[0].toString() + (sender.length > 1 ? '等' : '');
    final date = _message.decodeDate();
    final dateText = date != null ? context.formatYmdNum(date) : '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 20,
        child: Text(
          subjectText[0],
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[50]),
        ),
      ),
      // isThreeLine: true,
      title: Text(subjectText, style: titleStyle, maxLines: 1, overflow: TextOverflow.fade),
      subtitle: Text(senderText, style: subtitleStyle),
      trailing: Text(dateText, style: subtitleStyle),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(_message)));
      },
    );
  }
}
