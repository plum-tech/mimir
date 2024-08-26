import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';

import "i18n.dart";

const emailUrl = "http://imap.mail.sit.edu.cn";

class EduEmailAppCard extends ConsumerStatefulWidget {
  const EduEmailAppCard({super.key});

  @override
  ConsumerState<EduEmailAppCard> createState() => _EduEmailAppCardState();
}

class _EduEmailAppCardState extends ConsumerState<EduEmailAppCard> {
  @override
  Widget build(BuildContext context) {
    final credentials = ref.watch(CredentialsInit.storage.$eduEmailCredentials);
    final email = credentials?.account.toString();
    return AppCard(
      title: i18n.title.text(),
      subtitle: email != null ? SelectableText(email) : null,
      leftActions: kIsWeb
          ? [
              FilledButton.icon(
                onPressed: () async {
                  await launchUrlString(emailUrl, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.open_in_browser),
                label: i18n.action.open.text(),
              ),
            ]
          : credentials == null
              ? [
                  FilledButton.icon(
                    onPressed: () async {
                      await context.push("/edu-email/login");
                    },
                    icon: const Icon(Icons.login),
                    label: i18n.action.login.text(),
                  ),
                ]
              : [
                  FilledButton.icon(
                    onPressed: () {
                      context.push("/edu-email/inbox");
                    },
                    icon: const Icon(Icons.inbox),
                    label: i18n.action.inbox.text(),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.push("/edu-email/outbox");
                    },
                    icon: const Icon(Icons.outbox),
                    label: i18n.action.outbox.text(),
                  ),
                ],
    );
  }
}
