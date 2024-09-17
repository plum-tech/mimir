import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/me/edu_email/init.dart';
import 'package:mimir/settings/widget/credentials.dart';
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
            title: i18n.eduEmail.eduEmail.text(),
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    final credential = ref.watch(CredentialsInit.storage.eduEmail.$credentials);
    final all = <WidgetBuilder>[];
    if (credential != null) {
      all.add((_) => buildAccount(credential));
      all.add((_) => const Divider());
      all.add(
        (_) => PasswordDisplayTile(
          password: credential.password,
          onChanged: (pwd) {
            CredentialsInit.storage.eduEmail.credentials = credential.copyWith(password: pwd);
          },
        ),
      );
      all.add(
        (_) => LoginTestTile(
          credential: credential,
          login: () async {
            await EduEmailInit.service.login(credential);
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

  Widget buildAccount(Credential credential) {
    return ListTile(
      title: i18n.eduEmail.emailAddress.text(),
      subtitle: credential.account.text(),
      leading: Icon(context.icons.person),
      trailing: Icon(context.icons.copy),
      onTap: () async {
        context.showSnackBar(content: i18n.copyTipOf(i18n.eduEmail.emailAddress).text());
        // Copy the student ID to clipboard
        await Clipboard.setData(ClipboardData(text: credential.account));
      },
    );
  }
}
