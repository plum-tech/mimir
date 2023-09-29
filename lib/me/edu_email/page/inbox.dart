import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credential/entity/email.dart';
import 'package:mimir/credential/init.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../i18n.dart';
import '../widgets/list.dart';

// TODO: Send email
class EduEmailInboxPage extends StatefulWidget {
  const EduEmailInboxPage({super.key});

  @override
  State<StatefulWidget> createState() => _EduEmailInboxPageState();
}

class _EduEmailInboxPageState extends State<EduEmailInboxPage> {
  List<MimeMessage>? messages;
  EmailCredentials? credential = CredentialInit.storage.eduEmailCredentials;
  final onEduEmailChanged = CredentialInit.storage.listenEduEmailChange();

  @override
  void initState() {
    super.initState();
    onEduEmailChanged.addListener(updateCredential);
    refresh();
  }

  @override
  void dispose() {
    onEduEmailChanged.removeListener(updateCredential);
    super.dispose();
  }

  void updateCredential() {
    final newCredential = CredentialInit.storage.eduEmailCredentials;
    setState(() {
      credential = newCredential;
    });
    if (newCredential != null) {
      refresh();
    }
  }

  Future<void> refresh() async {
    final credential = this.credential;
    if (credential == null) return;
    try {
      await EduEmailInit.service.login(credential);
    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stacktrace);
      CredentialInit.storage.eduEmailCredentials = null;
      return;
    }
    try {
      final result = await EduEmailInit.service.getInboxMessage(30);
      final msgs = result.messages;
      // The more recent the time, the smaller the index in the list.
      msgs.sort((a, b) {
        return a.decodeDate()!.isAfter(b.decodeDate()!) ? -1 : 1;
      });
      if (!mounted) return;
      setState(() {
        messages = msgs;
      });
    } catch (err, stacktrace) {
      debugPrintStack(stackTrace: stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Using sliver
    return Scaffold(
      appBar: AppBar(
        title: (CredentialInit.storage.eduEmailCredentials?.address ?? i18n.title).text(),
        bottom: credential != null && messages == null
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final messages = this.messages;
    if (messages == null) {
      return const SizedBox();
    }
    return EduEmailList(messages: messages);
  }
}
