import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/design/widgets/dialog.dart';
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
    final credential = Auth.oaCredential;
    final all = <WidgetBuilder>[];
    if (credential == null) {
      all.add((_) => buildLogin());
    } else {
      all.add((_) => buildCredential(credential));
      all.add((_) => const Divider());
      all.add((_) => buildPassword(credential));
      all.add((_) => buildChangePassword());
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

  Widget buildCredential(OACredential credential) {
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

  var showPassword = false;

  Widget buildPassword(OACredential credential) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 100),
      child: ListTile(
        title: CredentialI18n.instance.oaPwd.text(),
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

  Widget buildChangePassword() {
    return ListTile(
      title: "Change password".text(),
      subtitle: "Change saved password without re-login".text(),
      leading: const Icon(Icons.key_rounded),
      onTap: () {

      },
    );
  }
}
