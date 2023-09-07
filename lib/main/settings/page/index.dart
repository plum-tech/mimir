import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/main/settings/page/developer.dart';
import 'package:mimir/route.dart';
import 'package:mimir/storage/meta.dart';
import 'package:mimir/storage/settings.dart';
import 'package:mimir/storage/page/editor.dart';
import 'package:mimir/utils/file.dart';
import 'package:mimir/utils/logger.dart';
import 'package:mimir/utils/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:unicons/unicons.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import '../../index.dart';
import '../i18n.dart';
import 'credential.dart';
import 'language.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    Settings.$isDeveloperMode.addListener(refresh);
  }

  @override
  void dispose() {
    Settings.$isDeveloperMode.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final entries = buildEntries();
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
            delegate: SliverChildBuilderDelegate(
              childCount: entries.length,
              (ctx, index) {
                return entries[index](ctx);
              },
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

  List<WidgetBuilder> buildEntries() {
    final all = <WidgetBuilder>[];

    final credential = context.auth.credential;
    if (credential != null) {
      all.add((_) => buildCredential(credential));
      all.add((_) => const Divider());
    }

    all.add((ctx) => buildLanguageSelector(ctx));
    all.add((_) => const ThemeModeTile());

    all.add((_) => const Divider());
    if (kDebugMode || Settings.isDeveloperMode) {
      all.add((_) => buildDeveloper());
    }
    all.add((_) => buildClearCache());
    all.add((_) => buildWipeData());
    all.add((_) => const VersionTile());
    return all;
  }

  Widget buildDarkMode() {
    return SizedBox();
  }

  Widget buildCampusSelector() {
    return ListTile(
      title: i18n.campus.title.text(),
      subtitle: i18n.campus.desc.text(),
      leading: const Icon(Icons.location_on),
      trailing: DropdownButton<int>(
        value: Settings.campus,
        icon: const Icon(Icons.arrow_downward),
        elevation: 8,
        onChanged: (int? value) {
          // This is called when the user selects an item.
          setState(() {
            Settings.campus = value!;
          });
          Global.eventBus.fire(EventTypes.onCampusChange);
        },
        items: [
          DropdownMenuItem<int>(
            value: 1,
            child: i18n.campus.fengxian.text(),
          ),
          DropdownMenuItem<int>(
            value: 2,
            child: i18n.campus.xuhui.text(),
          ),
        ],
      ),
    );
  }

  Widget buildLanguageSelector(BuildContext ctx) {
    final curLocale = ctx.locale;
    return ListTile(
      leading: const Icon(Icons.translate_rounded),
      title: i18n.language.title.text(),
      subtitle: i18n.language.languageOf(curLocale).text(),
      trailing: DropdownMenu<Locale>(
        initialSelection: curLocale,
        onSelected: (Locale? value) {
          if (value == null) return;
          if (!mounted) return;
          context.setLocale(value);
        },
        dropdownMenuEntries: R.supportedLocales
            .map<DropdownMenuEntry<Locale>>(
              (locale) => DropdownMenuEntry<Locale>(
                label: i18n.language.languageOf(locale),
                value: locale,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildCredential(OaCredential credential) {
    return ListTile(
      title: CredentialI18n.instance.oaAccount.text(),
      subtitle: credential.account.text(),
      leading: const Icon(Icons.person_rounded),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () async {
        await context.navigator.push(
          MaterialPageRoute(
            builder: (_) => const CredentialPage(),
          ),
        );
      },
    );
  }

  Widget buildDeveloper() {
    return ListTile(
      title: i18n.dev.title.text(),
      leading: const Icon(Icons.developer_mode_outlined),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () async {
        await context.navigator.push(
          MaterialPageRoute(
            builder: (_) => const DeveloperPage(),
          ),
        );
      },
    );
  }

  Widget buildChangePassword() {
    return SizedBox();
  }

  Widget buildClearCache() {
    return ListTile(
      title: i18n.clearCache.title.text(),
      subtitle: i18n.clearCache.desc.text(),
      leading: const Icon(Icons.folder_delete_outlined),
      onTap: () {
        _onClearCache(context);
      },
    );
  }

  Widget buildWipeData() {
    return ListTile(
      title: i18n.wipeData.title.text(),
      subtitle: i18n.wipeData.desc.text(),
      leading: const Icon(Icons.delete_forever_rounded),
      onTap: () {
        _onWipeData(context);
      },
    );
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
      await HiveBoxInit.clear(); // 清除存储
      await Init.init();
      if (!mounted) return;
      _gotoLogin(context);
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
      await HiveBoxInit.clearCache(); // 清除存储
    }
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

  void _gotoLogin(BuildContext ctx) {
    final navigator = ctx.navigator;
    while (navigator.canPop()) {
      navigator.pop();
    }
    ctx.go("/login");
  }
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
        "macOS" => const Icon(UniconsLine.apple),
        "iOS" => const Icon(UniconsLine.apple),
        "Android" => const Icon(Icons.android),
        "Linux" => const Icon(UniconsLine.linux),
        "Windows" => const Icon(UniconsLine.windows),
        _ => const Icon(Icons.device_unknown_outlined),
      },
      title: i18n.version.text(),
      onTap: Settings.isDeveloperMode && clickCount <= 10
          ? null
          : () {
              if (Settings.isDeveloperMode) return;
              clickCount++;
              if (clickCount >= 10) {
                Settings.isDeveloperMode = true;
                context.showSnackBar(Text("Developer mode is on."));
              }
            },
      subtitle: "${version.platform} ${version.full?.toString() ?? i18n.unknown}".text(),
    );
  }
}

class ThemeModeTile extends StatefulWidget {
  const ThemeModeTile({super.key});

  @override
  State<ThemeModeTile> createState() => _ThemeModeTileState();
}

class _ThemeModeTileState extends State<ThemeModeTile> {
  @override
  void initState() {
    super.initState();
    Settings.onThemeChanged.addListener(refresh);
  }

  @override
  void dispose() {
    Settings.onThemeChanged.removeListener(refresh);
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
