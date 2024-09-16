import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/me/edu_email/init.dart';
import 'package:mimir/settings/widget/login_test.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import '../i18n.dart';

class EduEmailSettingsPage extends ConsumerStatefulWidget {
  const EduEmailSettingsPage({super.key});

  @override
  ConsumerState<EduEmailSettingsPage> createState() => _EduEmailSettingsPageState();
}

class _EduEmailSettingsPageState extends ConsumerState<EduEmailSettingsPage> {
  var showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.oa.oaAccount.text(),
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    final credentials = ref.watch(CredentialsInit.storage.eduEmail.$credentials);
    final all = <WidgetBuilder>[];
    if (credentials != null) {
      all.add((_) => buildAccount(credentials));
      all.add((_) => const Divider());
      all.add((_) => buildPassword(credentials));
      all.add(
        (_) => LoginTestTile(
          credentials: credentials,
          login: () async {
            await EduEmailInit.service.login(credentials);
          },
        ),
      );
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

  Widget buildAccount(Credentials credential) {
    return ListTile(
      title: i18n.oa.oaAccount.text(),
      subtitle: credential.account.text(),
      leading: Icon(context.icons.person),
      trailing: Icon(context.icons.copy),
      onTap: () async {
        context.showSnackBar(content: i18n.copyTipOf(i18n.oa.oaAccount).text());
        // Copy the student ID to clipboard
        await Clipboard.setData(ClipboardData(text: credential.account));
      },
    );
  }

  Widget buildPassword(Credentials credential) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 100),
      child: ListTile(
        title: i18n.eduEmail.account.text(),
        subtitle: Text(!showPassword ? i18n.oa.savedOaPwdDesc : credential.password),
        leading: const Icon(Icons.password_rounded),
        trailing: [
          PlatformIconButton(
            icon: Icon(context.icons.edit),
            onPressed: () async {
              final newPwd = await Editor.showStringEditor(
                context,
                desc: i18n.oa.savedOaPwd,
                initial: credential.password,
              );
              if (newPwd != credential.password) {
                if (!mounted) return;
                CredentialsInit.storage.oa.credentials = credential.copyWith(password: newPwd);
                setState(() {});
              }
            },
          ),
          PlatformIconButton(
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
}
