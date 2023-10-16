import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/global/global.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/login/utils.dart';
import '../i18n.dart';

const _changePasswordUrl = "https://authserver.sit.edu.cn/authserver/passwordChange.do";

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

enum _TestLoginState {
  notStart,
  loggingIn,
  success,
}

class _CredentialsPageState extends State<CredentialsPage> {
  var showPassword = false;
  var loggingState = _TestLoginState.notStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.credentials.oaAccount.text(style: context.textTheme.headlineSmall),
            ),
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    final credential = context.auth.credentials;
    final all = <WidgetBuilder>[];
    if (credential != null) {
      all.add((_) => buildAccount(credential));
      all.add((_) => const Divider());
      all.add((_) => buildPassword(credential));
      all.add((_) => buildTestLogin(credential));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: all.length,
        (ctx, index) {
          return all[index](ctx);
        },
      ),
    );
  }

  Widget buildAccount(OaCredentials credential) {
    return ListTile(
      title: i18n.credentials.oaAccount.text(),
      subtitle: credential.account.text(),
      leading: const Icon(Icons.person_rounded),
      trailing: const Icon(Icons.copy_rounded),
      onTap: () {
        // Copy the student ID to clipboard
        Clipboard.setData(ClipboardData(text: credential.account));
        context.showSnackBar(i18n.studentId.studentIdCopy2ClipboardTip.text());
      },
    );
  }

  Widget buildPassword(OaCredentials credential) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 100),
      child: ListTile(
        title: i18n.credentials.savedOaPwd.text(),
        subtitle: Text(!showPassword ? i18n.credentials.savedOaPwdDesc : credential.password),
        leading: const Icon(Icons.password_rounded),
        trailing: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final newPwd = await Editor.showStringEditor(
                context,
                desc: i18n.credentials.savedOaPwd,
                initial: credential.password,
              );
              if (newPwd != credential.password) {
                if (!mounted) return;
                CredentialInit.storage.oaCredentials = credential.copyWith(password: newPwd);
                setState(() {});
              }
            },
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
        ].wrap(),
      ),
    );
  }

  Widget buildTestLogin(OaCredentials credential) {
    return ListTile(
      enabled: loggingState != _TestLoginState.loggingIn,
      title: i18n.credentials.testLoginOa.text(),
      subtitle: i18n.credentials.testLoginOaDesc.text(),
      leading: const Icon(Icons.login),
      trailing: switch (loggingState) {
        _TestLoginState.loggingIn => const CircularProgressIndicator(),
        _TestLoginState.success => const Icon(Icons.check, color: Colors.green),
        _ => null,
      },
      onTap: loggingState == _TestLoginState.loggingIn
          ? null
          : () async {
              setState(() => loggingState = _TestLoginState.loggingIn);
              try {
                await Global.ssoSession.loginLocked(credential);
                if (!mounted) return;
                setState(() => loggingState = _TestLoginState.success);
              } on Exception catch (error, stackTrace) {
                setState(() => loggingState = _TestLoginState.notStart);
                if (!mounted) return;
                await handleLoginException(context: context, error: error, stackTrace: stackTrace);
              }
            },
    );
  }
}
