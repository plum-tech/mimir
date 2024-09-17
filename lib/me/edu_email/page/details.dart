import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/widget/html.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';

// TODO: Better UI
class EduEmailDetailsPage extends StatelessWidget {
  final MimeMessage message;

  const EduEmailDetailsPage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final subject = message.decodeSubject() ?? i18n.noSubject;
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: subject.text(),
            ),
            SliverToBoxAdapter(
              child: MailMetaCard(message),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: RestyledHtmlWidget(
                _generateHtml(context, message),
                renderMode: RenderMode.sliverList,
              ),
            )
          ],
        ),
      ),
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
    return [Text(subject), Text('$senderText\n$dateText')].column().inCard();
  }
}
