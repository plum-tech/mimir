import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/school/yellow_pages/widget/contact.dart';
import 'package:mimir/widget/html.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/email.dart';
import '../i18n.dart';

class MailDetailsPage extends StatelessWidget {
  final MailEntity mail;

  const MailDetailsPage(this.mail, {super.key});

  @override
  Widget build(BuildContext context) {
    final date = mail.formatDate(context);
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: mail.senders.first.displayName.text(),
            ),
            SliverList.list(children: [
              ListTile(
                leading: ContactAvatar(name: mail.senders.first.displayName),
                title: mail.senders.first.email.text(),
                subtitle: [
                  mail.recipients.first.toString().text(),
                  if (date != null) date.text(),
                ].column(caa: CrossAxisAlignment.start),
              ),
              const Divider(),
              mail.subject.text(style: context.textTheme.titleLarge).padH(16),
            ]),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: RestyledHtmlWidget(
                async: false,
                context.isDarkMode ? mail.htmlDarkMode : mail.html,
                renderMode: RenderMode.sliverList,
              ),
            )
          ],
        ),
      ),
    );
  }
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
