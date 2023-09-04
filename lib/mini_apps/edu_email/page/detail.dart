import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

// TODO: Better UI
class DetailPage extends StatelessWidget {
  final MimeMessage message;

  const DetailPage(this.message, {Key? key}) : super(key: key);

  String _generateHtml(MimeMessage mimeMessage) {
    return mimeMessage.transformToHtml(
      blockExternalImages: false,
      emptyMessageText: i18n.noContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.text.text()),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54);

    final subjectText = message.decodeSubject() ?? i18n.noSubject;
    final sender = message.decodeSender();
    var senderText = sender[0].toString();
    if (sender.length > 1) {
      senderText += i18n.pluralSenderTailing;
    }
    final date = message.decodeDate();
    final dateText = date != null ? context.formatYmdhmsNum(date) : '';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(subjectText, style: titleStyle),
          Text('$senderText\n$dateText', style: subtitleStyle),
          Expanded(
            child: MyHtmlWidget(
              _generateHtml(message),
              // renderMode: RenderMode.listView,
            ),
          ),
        ],
      ),
    );
  }
}
