import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/design/widgets/editor.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

const _i18n = CredentialI18n();

class CredentialPage extends StatefulWidget {
  const CredentialPage({
    super.key,
  });

  @override
  State<CredentialPage> createState() => _CredentialPageState();
}

class _CredentialPageState extends State<CredentialPage> {
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
              title: _i18n.oaAccount.text(),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.logout_rounded), onPressed: () {}),
            ],
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    final credential = context.auth.credential;
    final all = <WidgetBuilder>[];
    if (credential == null) {
      all.add((_) => buildLogin());
    } else {
      all.add((_) => buildAccount(credential));
      all.add((_) => const Divider());
      all.add((_) => buildPassword(credential));
      all.add((_) => buildChangeSavedPassword(credential));
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
      onTap: () async {},
    );
  }

  Widget buildAccount(Credential credential) {
    return ListTile(
      title: CredentialI18n.instance.oaAccount.text(),
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

  Widget buildPassword(Credential credential) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 100),
      child: ListTile(
        title: CredentialI18n.instance.savedOaPwd.text(),
        subtitle: !showPassword ? null : credential.password.text(),
        leading: const Icon(Icons.password_rounded),
        trailing: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
        onTap: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
      ),
    );
  }

  Widget buildChangeSavedPassword(Credential origin) {
    return ListTile(
      title: CredentialI18n.instance.changeSavedOaPwd.text(),
      subtitle: CredentialI18n.instance.changeSavedOaPwdDesc.text(),
      leading: const Icon(Icons.key_rounded),
      onTap: () async {
        final newPwd =
            await Editor.showStringEditor(context, desc: CredentialI18n.instance.savedOaPwd, initial: origin.password);
        if (newPwd != origin.password) {
          if (!mounted) return;
          context.auth.setOaCredential(origin.copyWith(password: newPwd));
          setState(() {});
        }
      },
    );
  }
}
