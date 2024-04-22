import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/app.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/credentials/utils.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/init.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/login/aggregated.dart';
import 'package:sit/login/utils.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/design/widgets/navigation.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';
import '../i18n.dart';

class DeveloperOptionsPage extends ConsumerStatefulWidget {
  const DeveloperOptionsPage({
    super.key,
  });

  @override
  ConsumerState<DeveloperOptionsPage> createState() => _DeveloperOptionsPageState();
}

class _DeveloperOptionsPageState extends ConsumerState<DeveloperOptionsPage> {
  @override
  Widget build(BuildContext context) {
    final credentials = ref.watch(CredentialsInit.storage.$oaCredentials);
    final demoMode = ref.watch(Dev.$demoMode);
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
              const DebugExpenseUserOverrideTile(),
              if (credentials != null)
                SwitchOaUserTile(
                  currentCredentials: credentials,
                ),
              if (demoMode && credentials != R.demoModeOaCredentials)
                ListTile(
                  leading: const Icon(Icons.adb),
                  title: "Login demo account".text(),
                  trailing: const Icon(Icons.login),
                  onTap: () async {
                    Settings.lastSignature ??= "Liplum";
                    CredentialsInit.storage.oaCredentials = R.demoModeOaCredentials;
                    CredentialsInit.storage.oaLoginStatus = LoginStatus.validated;
                    CredentialsInit.storage.oaLastAuthTime = DateTime.now();
                    CredentialsInit.storage.oaUserType = OaUserType.undergraduate;
                    await Init.initModules();
                    if (!context.mounted) return;
                    context.go("/");
                  },
                ),
              const AppLinksTile(),
              const DebugGoRouteTile(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildDevModeToggle() {
    final on = ref.watch(Dev.$on);
    return ListTile(
      title: i18n.dev.devMode.text(),
      leading: const Icon(Icons.developer_mode_outlined),
      trailing: Switch.adaptive(
        value: on,
        onChanged: (newV) {
          ref.read(Dev.$on.notifier).set(newV);
        },
      ),
    );
  }

  Widget buildDemoModeToggle() {
    final demoMode = ref.watch(Dev.$demoMode);
    return ListTile(
      leading: const Icon(Icons.adb),
      title: i18n.dev.demoMode.text(),
      trailing: Switch.adaptive(
        value: demoMode,
        onChanged: (newV) async {
          ref.read(Dev.$demoMode.notifier).set(newV);
          await Init.initModules();
        },
      ),
    );
  }

  Widget buildReload() {
    return ListTile(
      title: i18n.dev.reload.text(),
      subtitle: i18n.dev.reloadDesc.text(),
      leading: Icon(context.icons.refresh),
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

class AppLinksTile extends ConsumerWidget {
  const AppLinksTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLinks = ref.watch($appLinks);
    return AnimatedExpansionTile(
      leading: const Icon(Icons.link),
      title: "App links".text(),
      children: appLinks
          .map((uri) => ListTile(
                title: context.formatYmdhmsNum(uri.ts).text(),
                subtitle: Uri.decodeFull(uri.uri.toString()).text(),
              ))
          .toList(),
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
            (ctx, route) => PlatformIconButton(
                  onPressed: route.text.isEmpty
                      ? null
                      : () {
                          context.push(route.text);
                        },
                  icon: const Icon(Icons.arrow_forward),
                )
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
    final credentialsList = Dev.getSavedOaCredentialsList() ?? [];
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
      leading: Icon(context.icons.accountCircle),
      title: credentials.account.text(),
      subtitle: isCurrent ? "Current user".text() : estimateOaUserType(credentials.account)?.l10n().text(),
      trailing: const Icon(Icons.login).padAll(8),
      enabled: !isCurrent,
      onTap: () async {
        await loginWith(credentials);
      },
      onLongPress: () async {
        context.showSnackBar(content: i18n.copyTipOf(i18n.oaCredentials.oaAccount).text());
        await Clipboard.setData(ClipboardData(text: credentials.account));
      },
    ).padH(12);
  }

  Widget buildLoginNewTile() {
    return ListTile(
      leading: Icon(context.icons.add),
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
      final former = Dev.getSavedOaCredentialsList() ?? [];
      former.add(credentials);
      await Dev.setSavedOaCredentialsList(former);
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

class DebugExpenseUserOverrideTile extends ConsumerWidget {
  const DebugExpenseUserOverrideTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(Dev.$expenseUserOverride);
    return ListTile(
      leading: Icon(context.icons.person),
      title: "Expense user".text(),
      subtitle: user?.text(),
      onTap: () async {
        final res = await Editor.showStringEditor(
          context,
          desc: "OA account",
          initial: user ?? "",
        );
        if (res == null) return;
        if (res.isEmpty) {
          ref.read(Dev.$expenseUserOverride.notifier).set(null);
          return;
        }
        if (estimateOaUserType(res) == null) {
          if (!context.mounted) return;
          await context.showTip(
            title: "Error",
            desc: "Invalid OA account format.",
            primary: "OK",
          );
        } else {
          ref.read(Dev.$expenseUserOverride.notifier).set(res);
        }
      },
      trailing: Icon(context.icons.edit),
    );
  }
}
