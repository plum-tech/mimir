import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/credential/i18n.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/session/widgets/scope.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/settings/widgets/campus.dart';
import 'package:mimir/version.dart';
import 'package:rettulf/rettulf.dart';
import 'package:unicons/unicons.dart';

import '../i18n.dart';
import '../widgets/navigation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final $isDeveloperMode = Settings.listenIsDeveloperMode();

  @override
  void initState() {
    super.initState();
    $isDeveloperMode.addListener(refresh);
  }

  @override
  void dispose() {
    $isDeveloperMode.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.title.text(style: context.textTheme.headlineSmall),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              buildEntries(),
            ),
          ),
        ],
      ),
    );
/*
      SettingsGroup(title: i18n.networking, children: <Widget>[
        SwitchSettingsTile(
          settingKey: '/network/useProxy',
          defaultValue: Kv.network.useProxy,
          title: i18n.settingsHttpProxy,
          subtitle: i18n.settingsHttpProxySub,
          leading: const Icon(Icons.vpn_key),
          onChange: (value) async {
            Kv.network.useProxy = value;
            await Initializer.init();
          },
          childrenIfEnabled: [
            SwitchSettingsTile(
              settingKey: '/network/isGlobalProxy',
              defaultValue: Kv.network.isGlobalProxy,
              title: i18n.settingsHttpProxyGlobal,
              subtitle: i18n.settingsHttpProxyGlobalSub,
              leading: const Icon(Icons.network_check),
              onChange: (value) async {
                Kv.network.isGlobalProxy = value;
                await Initializer.init(debugNetwork: value);
              },
            ),
            TextInputSettingsTile(
              title: i18n.settingsProxyAddress,
              settingKey: '/network/proxy',
              initialValue: Kv.network.proxy,
              validator: proxyValidator,
              onChange: (value) async {
                Kv.network.proxy = value;
                if (Kv.network.useProxy) {
                  await Initializer.init();
                }
              },
            ),
            SimpleSettingsTile(
                title: i18n.settingsTestConnect2School,
                subtitle: i18n.settingsTestConnect2SchoolSub,
                onTap: () {
                  Navigator.pushNamed(context, Routes.networkTool);
                }),
          ],
        ),
      ]),
    ]);*/
  }

  List<Widget> buildEntries() {
    final all = <Widget>[];
    final auth = context.auth;
    if (auth.loginStatus != LoginStatus.never) {
      all.add(const CampusSelector().padSymmetric(h: 8));
    }
    final credential = auth.credentials;
    if (credential != null) {
      all.add(PageNavigationTile(
        title: CredentialI18n.instance.oaAccount.text(),
        subtitle: credential.account.text(),
        icon: const Icon(Icons.person_rounded),
        path: "/settings/credentials",
      ));
    }
    all.add(const Divider());

    all.add(const LanguageSelectorTile());
    all.add(const ThemeModeTile());
    all.add(const Divider());

    if (auth.loginStatus != LoginStatus.never) {
      all.add(PageNavigationTile(
        title: i18n.timetable.title.text(),
        icon: const Icon(Icons.calendar_month_outlined),
        path: "/settings/timetable",
      ));
      all.add(PageNavigationTile(
        title: i18n.school.title.text(),
        icon: const Icon(Icons.school_outlined),
        path: "/settings/school",
      ));
      all.add(PageNavigationTile(
        title: i18n.life.title.text(),
        icon: const Icon(Icons.spa_outlined),
        path: "/settings/life",
      ));
      all.add(const Divider());
    }
    if (Settings.isDeveloperMode) {
      all.add(PageNavigationTile(
        title: i18n.dev.title.text(),
        icon: const Icon(Icons.developer_mode_outlined),
        path: "/settings/developer",
      ));
    }
    all.add(PageNavigationTile(
      title: i18n.proxy.title.text(),
      subtitle: i18n.proxy.desc.text(),
      icon: const Icon(Icons.vpn_key),
      path: "/settings/proxy",
    ));
    if (auth.loginStatus != LoginStatus.never) {
      all.add(const ClearCacheTile());
    }
    all.add(const WipeDataTile());
    all.add(const VersionTile());
    return all;
  }

/*

  void _testPassword(BuildContext context, OACredential oaCredential) async {
    try {
      await Global.ssoSession.loginActive(oaCredential);
      if (!mounted) return;
      await context.showTip(title: i18n.success, desc: i18n.loginSuccessfulTip, ok: i18n.close);
    } catch (e) {
      if (!mounted) return;
      await context.showTip(title: i18n.loginFailedWarn, desc: e.toString().split('\n')[0], ok: i18n.close);
    }
  }
*/
}

class VersionTile extends StatefulWidget {
  const VersionTile({super.key});

  @override
  State<VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<VersionTile> {
  int clickCount = 0;
  final $isDeveloperMode = Settings.listenIsDeveloperMode();

  @override
  void initState() {
    super.initState();
    $isDeveloperMode.addListener(refresh);
  }

  @override
  void dispose() {
    $isDeveloperMode.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final version = Init.currentVersion;
    return ListTile(
      leading: switch (version.platform) {
        AppPlatform.iOS || AppPlatform.macOS => const Icon(UniconsLine.apple),
        AppPlatform.android => const Icon(Icons.android),
        AppPlatform.linux => const Icon(UniconsLine.linux),
        AppPlatform.windows => const Icon(UniconsLine.windows),
        AppPlatform.web => const Icon(UniconsLine.browser),
        AppPlatform.unknown => const Icon(Icons.device_unknown_outlined),
      },
      title: i18n.version.text(),
      onTap: Settings.isDeveloperMode && clickCount <= 10
          ? null
          : () {
              if (Settings.isDeveloperMode) return;
              clickCount++;
              if (clickCount >= 10) {
                clickCount = 0;
                Settings.isDeveloperMode = true;
                context.showSnackBar(const Text("Developer mode is on."));
              }
            },
      subtitle: "${version.platform.name} ${version.full?.toString() ?? i18n.unknown}".text(),
    );
  }
}

class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        leading: switch (Settings.themeMode) {
          ThemeMode.dark => const Icon(Icons.dark_mode),
          ThemeMode.light => const Icon(Icons.light_mode),
          ThemeMode.system => const Icon(Icons.brightness_6),
        },
        title: i18n.themeMode.title.text(),
        trailing: SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 4)),
          ),
          segments: ThemeMode.values
              .map((e) => ButtonSegment<ThemeMode>(
                    value: e,
                    label: i18n.themeMode.of(e).text(),
                  ))
              .toList(),
          selected: <ThemeMode>{Settings.themeMode},
          onSelectionChanged: (newSelection) {
            setState(() {
              Settings.themeMode = newSelection.first;
            });
          },
        ),
      ),
    );
  }
}

class LanguageSelectorTile extends StatelessWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    final curLocale = context.locale;
    return ListTile(
      leading: const Icon(Icons.translate_rounded),
      title: i18n.language.title.text(),
      subtitle: i18n.language.languageOf(curLocale).text(),
      trailing: DropdownMenu<Locale>(
        initialSelection: curLocale,
        onSelected: (Locale? locale) async {
          if (locale == null) return;
          await context.setLocale(locale);
          final engine = WidgetsFlutterBinding.ensureInitialized();
          engine.performReassemble();
        },
        dropdownMenuEntries: R.supportedLocales
            .map<DropdownMenuEntry<Locale>>(
              (locale) => DropdownMenuEntry<Locale>(
                value: locale,
                label: i18n.language.languageOf(locale),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ClearCacheTile extends StatelessWidget {
  const ClearCacheTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: i18n.clearCache.title.text(),
      subtitle: i18n.clearCache.desc.text(),
      leading: const Icon(Icons.folder_delete_outlined),
      onTap: () {
        _onClearCache(context);
      },
    );
  }
}

void _onClearCache(BuildContext context) async {
  final confirm = await context.showRequest(
    title: i18n.clearCache.title,
    desc: i18n.clearCache.request,
    yes: i18n.confirm,
    no: i18n.notNow,
    highlight: true,
    serious: true,
  );
  if (confirm == true) {
    await HiveInit.clearCache();
  }
}

class WipeDataTile extends StatelessWidget {
  const WipeDataTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: i18n.wipeData.title.text(),
      subtitle: i18n.wipeData.desc.text(),
      leading: const Icon(Icons.delete_forever_rounded),
      onTap: () {
        _onWipeData(context);
      },
    );
  }
}

void _onWipeData(BuildContext context) async {
  final confirm = await context.showRequest(
    title: i18n.wipeData.request,
    desc: i18n.wipeData.requestDesc,
    yes: i18n.confirm,
    no: i18n.notNow,
    highlight: true,
    serious: true,
  );
  if (confirm == true) {
    await HiveInit.clear(); // 清除存储
    await Init.init();
    if (!context.mounted) return;
    OaOnlineManagerState.of(context).isOnline = false;
    _gotoLogin(context);
  }
}

void _gotoLogin(BuildContext context) {
  final navigator = context.navigator;
  while (navigator.canPop()) {
    navigator.pop();
  }
  context.go("/login");
}
