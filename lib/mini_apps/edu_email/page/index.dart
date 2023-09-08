import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/edu_email/page/list.dart';
import 'package:mimir/mini_apps/edu_email/widgets/form.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../using.dart';

// TODO: Send email
class EduEmailPage extends StatefulWidget {
  const EduEmailPage({super.key});

  @override
  State<StatefulWidget> createState() => _EduEmailPageState();
}

class _EduEmailPageState extends State<EduEmailPage> {
  List<MimeMessage>? messages;
  EmailCredential? credential = CredentialInit.storage.eduEmailCredential;
  final onEduEmailChanged = CredentialInit.storage.onEduEmailChanged;

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
    final newCredential = CredentialInit.storage.eduEmailCredential;
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
    } catch (err, stacktrace) {
      debugPrintStack(stackTrace: stacktrace);
      CredentialInit.storage.eduEmailCredential = null;
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
    return Scaffold(
      appBar: AppBar(
        title: (CredentialInit.storage.eduEmailCredential?.address ?? i18n.title).text(),
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
    if (credential == null) {
      return EduEmailCredentialForm(studentId: context.auth.credential?.account);
    }
    final messages = this.messages;
    if (messages == null) {
      return const SizedBox();
    }
    return EduEmailList(messages: messages);
  }
}
