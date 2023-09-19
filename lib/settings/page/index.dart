import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/i18n.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/version.dart';
import 'package:rettulf/rettulf.dart';
import 'package:unicons/unicons.dart';

import '../i18n.dart';

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
            snap: false,
            floating: false,
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

    final credential = context.auth.credentials;
    if (credential != null) {
      all.add(CredentialTile(credential: credential));
      all.add(const Divider());
    }

    all.add(const CampusSelectorTile());

    all.add(const LanguageSelectorTile());
    all.add(const ThemeModeTile());

    all.add(const Divider());
    if (Settings.isDeveloperMode) {
      all.add(const DevOptionsTile());
    }
    all.add(const ClearCacheTile());
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

class ThemeModeTile extends StatefulWidget {
  const ThemeModeTile({super.key});

  @override
  State<ThemeModeTile> createState() => _ThemeModeTileState();
}

class _ThemeModeTileState extends State<ThemeModeTile> {
  final $themeMode = Settings.listenThemeMode();

  @override
  void initState() {
    super.initState();
    $themeMode.addListener(refresh);
  }

  @override
  void dispose() {
    $themeMode.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Settings.themeMode;
    return ListTile(
      leading: switch (themeMode) {
        ThemeMode.dark => const Icon(Icons.dark_mode),
        ThemeMode.light => const Icon(Icons.light_mode),
        ThemeMode.system => const Icon(Icons.brightness_6),
      },
      title: i18n.themeMode.title.text(),
      onTap: () {
        final current = Settings.themeMode;
        final newThemeMode = ThemeMode.values[(current.index + 1) % ThemeMode.values.length];
        Settings.themeMode = newThemeMode;
      },
      subtitle: i18n.themeMode.of(themeMode).text(),
    );
  }
}

class CampusSelectorTile extends StatefulWidget {
  const CampusSelectorTile({super.key});

  @override
  State<CampusSelectorTile> createState() => _CampusSelectorTileState();
}

class _CampusSelectorTileState extends State<CampusSelectorTile> {
  final $campus = Settings.listenCampus();

  @override
  void initState() {
    super.initState();
    $campus.addListener(refresh);
  }

  @override
  void dispose() {
    $campus.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: i18n.campus.title.text(),
      subtitle: i18n.campus.desc.text(),
      leading: const Icon(Icons.location_on),
      trailing: SegmentedButton<Campus>(
        showSelectedIcon: false,
        segments: <ButtonSegment<Campus>>[
          ButtonSegment<Campus>(value: Campus.fengxian, label: Campus.fengxian.l10nName().text()),
          ButtonSegment<Campus>(value: Campus.xuhui, label: Campus.xuhui.l10nName().text()),
        ],
        selected: <Campus>{Settings.campus},
        onSelectionChanged: (newSelection) {
          setState(() {
            Settings.campus = newSelection.first;
          });
        },
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

class DevOptionsTile extends StatelessWidget {
  const DevOptionsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: i18n.dev.title.text(),
      leading: const Icon(Icons.developer_mode_outlined),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () {
        context.push("/settings/developer");
      },
    );
  }
}

class CredentialTile extends StatelessWidget {
  final OaCredentials credential;

  const CredentialTile({
    super.key,
    required this.credential,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CredentialI18n.instance.oaAccount.text(),
      subtitle: credential.account.text(),
      leading: const Icon(Icons.person_rounded),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () async {
        context.push("/settings/credentials");
      },
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
