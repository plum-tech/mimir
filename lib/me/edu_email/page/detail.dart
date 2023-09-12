import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/widgets/html.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';

// TODO: Better UI
class DetailPage extends StatelessWidget {
  final MimeMessage message;

  const DetailPage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final subject = message.decodeSubject() ?? i18n.noSubject;

    return Scaffold(
      appBar: AppBar(
        title: subject.text(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MailMetaCard(message),
          StyledHtmlWidget(
            _generateHtml(context, message),
            // renderMode: RenderMode.listView,
          ),
        ],
      ).scrolled(),
    );
  }
}

String _generateHtml(BuildContext context, MimeMessage mimeMessage) {
  return mimeMessage.transformToHtml(
    blockExternalImages: false,
    preferPlainText: true,
    enableDarkMode: context.isDarkMode,
    emptyMessageText: i18n.noContent,
  );
}

class MailMetaCard extends StatelessWidget {
  final MimeMessage message;
  const MailMetaCard(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final subject = message.decodeSubject() ?? i18n.noSubject;
    final sender = message.decodeSender();
    var senderText = sender[0].toString();
    if (sender.length > 1) {
      senderText += i18n.pluralSenderTailing;
    }
    final date = message.decodeDate();
    final dateText = date != null ? context.formatYmdhmsNum(date) : '';
    return [
      Text(subject),
      Text('$senderText\n$dateText')
    ].column().inCard();
  }
}
