import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/credentials/utils.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/init.dart';
import 'package:sit/login/aggregated.dart';
import 'package:sit/login/utils.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/design/widgets/navigation.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({
    super.key,
  });

  @override
  State<DeveloperOptionsPage> createState() => _DeveloperOptionsPageState();
}

class _DeveloperOptionsPageState extends State<DeveloperOptionsPage> {
  @override
  Widget build(BuildContext context) {
    final oaCredentials = CredentialsInit.storage.oaCredentials;
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.dev.title.text(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildDevModeToggle(),
              buildDemoModeToggle(),
              PageNavigationTile(
                title: i18n.dev.localStorage.text(),
                subtitle: i18n.dev.localStorageDesc.text(),
                leading: const Icon(Icons.storage),
                path: "/settings/developer/local-storage",
              ),
              buildReload(),
              if (oaCredentials != null)
                SwitchOaUserTile(
                  currentCredentials: oaCredentials,
                ),
              const DebugGoRouteTile(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildDevModeToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.dev.devMode.text(),
        leading: const Icon(Icons.developer_mode_outlined),
        trailing: Switch.adaptive(
          value: Settings.devMode,
          onChanged: (newV) {
            setState(() {
              Settings.devMode = newV;
            });
          },
        ),
      ),
    );
  }

  Widget buildDemoModeToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.dev.demoMode.text(),
        trailing: Switch.adaptive(
          value: Settings.demoMode,
          onChanged: (newV) {
            setState(() {
              Settings.demoMode = newV;
            });
          },
        ),
      ),
    );
  }

  Widget buildReload() {
    return ListTile(
      title: i18n.dev.reload.text(),
      subtitle: i18n.dev.reloadDesc.text(),
      leading: const Icon(Icons.refresh_rounded),
      onTap: () async {
        await Init.initNetwork();
        await Init.initModules();
        final engine = WidgetsFlutterBinding.ensureInitialized();
        engine.performReassemble();
        if (!mounted) return;
        context.navigator.pop();
      },
    );
  }
}

class DebugGoRouteTile extends StatefulWidget {
  const DebugGoRouteTile({super.key});

  @override
  State<DebugGoRouteTile> createState() => _DebugGoRouteTileState();
}

class _DebugGoRouteTileState extends State<DebugGoRouteTile> {
  final $route = TextEditingController();

  @override
  void dispose() {
    $route.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.route_outlined),
      title: "Go route".text(),
      subtitle: TextField(
        controller: $route,
        decoration: const InputDecoration(
          hintText: "/anywhere",
        ),
      ),
      trailing: [
        $route >>
            (ctx, route) => IconButton(
                onPressed: route.text.isEmpty
                    ? null
                    : () {
                        context.push(route.text);
                      },
                icon: const Icon(Icons.arrow_forward))
      ].row(mas: MainAxisSize.min),
    );
  }
}

class SwitchOaUserTile extends StatefulWidget {
  final Credentials currentCredentials;

  const SwitchOaUserTile({
    super.key,
    required this.currentCredentials,
  });

  @override
  State<SwitchOaUserTile> createState() => _SwitchOaUserTileState();
}

class _SwitchOaUserTileState extends State<SwitchOaUserTile> {
  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    final credentialsList = Settings.getSavedOaCredentialsList() ?? [];
    if (credentialsList.none((c) => c.account == widget.currentCredentials.account)) {
      credentialsList.add(widget.currentCredentials);
    }
    return AnimatedExpansionTile(
      title: "Switch OA user".text(),
      subtitle: "Without logging out".text(),
      initiallyExpanded: true,
      leading: const Icon(Icons.swap_horiz),
      trailing: isLoggingIn
          ? const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator.adaptive(),
            )
          : null,
      children: [
        ...credentialsList.map(buildCredentialsHistoryTile),
        buildLoginNewTile(),
      ],
    );
  }

  Widget buildCredentialsHistoryTile(Credentials credentials) {
    final isCurrent = credentials == widget.currentCredentials;
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: credentials.account.text(),
      subtitle: isCurrent ? "Current user".text() : estimateOaUserType(credentials.account)?.l10n().text(),
      trailing: const Icon(Icons.login).padAll(8),
      enabled: !isCurrent,
      onTap: () async {
        await loginWith(credentials);
      },
    ).padH(12);
  }

  Widget buildLoginNewTile() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: "New account".text(),
      onTap: () async {
        final credentials = await await Editor.showAnyEditor(
          context,
          Credentials(account: "", password: ""),
        );
        if (credentials == null) return;
        await loginWith(credentials);
      },
    ).padH(12);
  }

  Future<void> loginWith(Credentials credentials) async {
    setState(() => isLoggingIn = true);
    try {
      await Init.cookieJar.deleteAll();
      await LoginAggregated.login(credentials);
      final former = Settings.getSavedOaCredentialsList() ?? [];
      former.add(credentials);
      await Settings.setSavedOaCredentialsList(former);
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      context.go("/");
    } on Exception catch (error, stackTrace) {
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      await handleLoginException(context: context, error: error, stackTrace: stackTrace);
    }
  }
}
