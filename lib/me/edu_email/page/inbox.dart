import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/animation/progress.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/utils/error.dart';

import '../entity/email.dart';
import '../init.dart';
import '../i18n.dart';
import '../widget/item.dart';
import 'details.dart';

class EduEmailInboxPage extends ConsumerStatefulWidget {
  const EduEmailInboxPage({super.key});

  @override
  ConsumerState<EduEmailInboxPage> createState() => _EduEmailInboxPageState();
}

class _EduEmailInboxPageState extends ConsumerState<EduEmailInboxPage> {
  List<MailEntity>? mails;
  var fetching = false;

  @override
  initState() {
    super.initState();
    final credentials = ref.read(CredentialsInit.storage.eduEmail.$credentials);
    if (credentials != null) {
      refresh(credentials);
    }
  }

  Future<void> refresh(Credential credentials) async {
    if (!mounted) return;
    setState(() {
      fetching = true;
    });
    try {
      await EduEmailInit.service.login(credentials);
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      CredentialsInit.storage.eduEmail.credentials = null;
      setState(() {
        fetching = false;
      });
      return;
    }
    try {
      final mails = await EduEmailInit.service.getInboxEmails();
      // The more recent the time, the smaller the index in the list.
      if (!mounted) return;
      setState(() {
        fetching = false;
        this.mails = mails;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      setState(() {
        fetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mails = this.mails;
    return Scaffold(
      floatingActionButton: fetching ? const AnimatedProgressCircle() : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.inbox.title.text(),
          ),
          if (mails != null)
            SliverList.separated(
              itemCount: mails.length,
              separatorBuilder: (ctx, i) => const Divider(
                height: 4,
                indent: 16,
                endIndent: 8,
              ),
              itemBuilder: (ctx, i) {
                final mail = mails[i];
                return InkWell(
                  onTap: () {
                    context.showSheet(
                      (_) => MailDetailsPage(mail),
                      dismissible: false,
                    );
                  },
                  child: EmailItem(mail).padSymmetric(h: 16, v: 8),
                );
              },
            )
        ],
      ),
    );
  }
}
