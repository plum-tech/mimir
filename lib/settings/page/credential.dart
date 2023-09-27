import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/i18n.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/global/global.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

const _changePasswordUrl = "https://authserver.sit.edu.cn/authserver/passwordChange.do";

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  var showPassword = false;

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
              title: i18n.credential.oaAccount.text(style: context.textTheme.headlineSmall),
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
    if (credential == null) {
      all.add((_) => buildLogin());
    } else {
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

  Widget buildLogin() {
    return ListTile(
      title: "Login".text(),
      subtitle: "Please login".text(),
      leading: const Icon(Icons.person_rounded),
      onTap: () async {
        // TODO: Login
      },
    );
  }

  Widget buildAccount(OaCredentials credential) {
    return ListTile(
      title: i18n.credential.oaAccount.text(),
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
        title: i18n.credential.savedOaPwd.text(),
        subtitle: Text(!showPassword ? i18n.credential.savedOaPwdDesc : credential.password),
        leading: const Icon(Icons.password_rounded),
        trailing: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final newPwd = await Editor.showStringEditor(
                context,
                desc: i18n.credential.savedOaPwd,
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
    // TODO: i18n
    return ListTile(
      title: "Test login OA".text(),
      subtitle: "Try to login OA with current credentials".text(),
      leading: const Icon(Icons.login),
      onTap: () async {
        try {
          await Global.ssoSession.loginActiveLocked(credential);
          if (!mounted) return;
          await context.showTip(title: "OK", desc: "OK", ok: i18n.close);
        } catch (e) {
          if (!mounted) return;
          await context.showTip(title: "ERROR", desc: e.toString(), ok: i18n.close);
        }
      },
    );
  }
}
