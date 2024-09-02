import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/widgets/navigation.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';

import '../../i18n.dart';

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
            title: R.accountNameL10n.text(),
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

  Widget buildSignOut() {
    return ListTile(
      title: i18n.auth.signOut.text(),
      // subtitle: "Sign out your Ing Account".text(),
      leading: const Icon(Icons.logout),
      onTap: () async {
        CredentialsInit.storage.mimir.signedIn = false;
      },
    );
  }
}

class MimirCredentialsSettingsTile extends ConsumerWidget {
  const MimirCredentialsSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(CredentialsInit.storage.mimir.$signedIn);
    if (signedIn) {
      return PageNavigationTile(
        title: R.accountNameL10n.text(),
        leading: const Icon(Icons.person_rounded),
        path: "/settings/mimir",
      );
    } else {
      return ListTile(
        title: i18n.auth.signInTitle.text(),
        leading: const Icon(Icons.person_rounded),
        onTap: () {
          context.push("/mimir/sign-in");
        },
      );
    }
  }
}
