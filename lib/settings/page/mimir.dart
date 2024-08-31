import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import '../i18n.dart';

class MimirSettingsPage extends ConsumerStatefulWidget {
  const MimirSettingsPage({super.key});

  @override
  ConsumerState<MimirSettingsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends ConsumerState<MimirSettingsPage> {
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
            title: "SIT Life account".text(),
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    final signedIn = ref.watch(CredentialsInit.storage.mimir.$signedIn);
    final all = <WidgetBuilder>[];
    if (signedIn) {
      all.add((_) => buildSignOut());
    }
    // if (credentials != null) {
    //   all.add((_) => buildAccount(credentials));
    //   all.add((_) => const Divider());
    //   all.add((_) => buildPassword(credentials));
    //   all.add((_) => TestLoginTile(credentials: credentials));
    // }
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
      title: i18n.oaCredentials.oaAccount.text(),
      subtitle: credential.account.text(),
      leading: Icon(context.icons.person),
      trailing: Icon(context.icons.copy),
      onTap: () async {
        context.showSnackBar(content: i18n.copyTipOf(i18n.oaCredentials.oaAccount).text());
        // Copy the student ID to clipboard
        await Clipboard.setData(ClipboardData(text: credential.account));
      },
    );
  }

  Widget buildSignOut() {
    return ListTile(
      title: "Sign out".text(),
      subtitle: "Sign out your SIT Life account".text(),
      leading: const Icon(Icons.logout),
      onTap: () async {
        CredentialsInit.storage.mimir.signedIn = false;
      },
    );
  }
}
