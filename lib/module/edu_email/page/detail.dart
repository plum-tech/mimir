import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class DetailPage extends StatelessWidget {
  final MimeMessage _message;

  const DetailPage(this._message, {Key? key}) : super(key: key);

  String _generateHtml(MimeMessage mimeMessage) {
    return mimeMessage.transformToHtml(
      blockExternalImages: false,
      emptyMessageText: i18n.eduEmailNoContent,
    );
  }

  Widget _buildBody(BuildContext context) {
    // final html = _message.decodeContentText() ?? '';
    final titleStyle = Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black54);

    final subjectText = _message.decodeSubject() ?? i18n.eduEmailNoSubject;
    final sender = _message.decodeSender();
    var senderText = sender[0].toString();
    if (sender.length > 1) {
      senderText += i18n.eduEmailPluralSenderTailing;
    }
    final date = _message.decodeDate();
    final dateText = date != null ? context.dateFullNum(date) : '';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(subjectText, style: titleStyle),
          Text('$senderText\n$dateText', style: subtitleStyle),
          Expanded(
            child: MyHtmlWidget(
              _generateHtml(_message),
              // renderMode: RenderMode.listView,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.eduEmailText.text()),
      body: _buildBody(context),
    );
  }
}
