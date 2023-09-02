import 'dart:convert';
import 'dart:io';

import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/main/settings/page/developer.dart';
import 'package:mimir/route.dart';
import 'package:mimir/storage/init.dart';
import 'package:mimir/storage/page/editor.dart';
import 'package:mimir/storage/storage/develop.dart';
import 'package:mimir/util/file.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/util/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../index.dart';
import '../i18n.dart';
import 'credential.dart';
import 'language.dart';

class SettingsPage extends StatefulWidget {
  final Widget? leading;

  const SettingsPage({super.key, this.leading});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final oaCredential = context.auth.oaCredential;
    _passwordController.text = oaCredential?.password ?? '';
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
            leading: widget.leading,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.title.text(),
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
/*    return SettingsScreen(title: i18n.settingsTitle, children: [
      // Personalize
      SettingsGroup(
        title: i18n.personalizeTitle,
        children: <Widget>[
          ColorPickerSettingsTile(
            title: i18n.settingsThemeColor,
            leading: const Icon(Icons.palette_outlined),
            settingKey: ThemeKeys.themeColor,
            defaultValue: Kv.theme.color,
            onChange: (newColor) => DynamicColorTheme.of(context).setColor(
              color: newColor,
              shouldSave: true, // saves it to shared preferences
            ),
          ),
          _buildLanguagePrefSelector(context),
          SwitchSettingsTile(
            settingKey: ThemeKeys.isDarkMode,
            defaultValue: Kv.theme.isDarkMode ?? false,
            title: i18n.settingsDarkMode,
            subtitle: i18n.settingsDarkModeSub,
            leading: const Icon(Icons.dark_mode),
            onChange: (value) => DynamicColorTheme.of(context).setIsDark(isDark: value, shouldSave: false),
          ),
        ],
      ),

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
      // Account
      SettingsGroup(
        title: i18n.account,
        children: <Widget>[
          if (oaCredential != null)
            ModalSettingsTile(
              title: i18n.settingsChangeOaPwd,
              subtitle: i18n.settingsChangeOaPwdSub,
              leading: const Icon(Icons.lock),
              showConfirmation: true,
              onConfirm: () {
                context.auth.oaCredential = oaCredential.copyWith(
                  password: _passwordController.text,
                );
                return true;
              },
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(controller: _passwordController, obscureText: true),
                ),
              ],
            ),
          if (oaCredential != null)
            SimpleSettingsTile(
                title: i18n.settingsTestLoginKite,
                subtitle: i18n.settingsTestLoginKiteSub,
                leading: const Icon(Icons.login_rounded),
                onTap: () => _testPassword(context, oaCredential)),
        ],
      ),
      SettingsGroup(
        title: i18n.devOptions,
        children: <Widget>[
          SwitchSettingsTile(
              settingKey: DevelopOptionsKeys.showErrorInfoDialog,
              defaultValue: Kv.developOptions.showErrorInfoDialog ?? false,
              title: i18n.settingsDetailedXcpDialog,
              subtitle: i18n.settingsDetailedXcpDialogSub,
              leading: const Icon(Icons.info),
              onChange: (value) {
                Kv.developOptions.showErrorInfoDialog = value;
              }),
        ],
      ),
    ]);*/
  }

  List<WidgetBuilder> buildEntries() {
    final all = <WidgetBuilder>[];

    final credential = context.auth.oaCredential;
    if (credential != null) {
      all.add((_) => buildCredential(credential));
    }
    all.add((ctx) => buildLanguageSelector(ctx));
    all.add((_) => const Divider());
    all.add((_) => buildDeveloper());
    all.add((_) => buildClearCache());
    all.add((_) => buildWipeData());
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
        value: Kv.home.campus,
        icon: const Icon(Icons.arrow_downward),
        elevation: 8,
        onChanged: (int? value) {
          // This is called when the user selects an item.
          setState(() {
            Kv.home.campus = value!;
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
      subtitle: "language.$curLocale".tr().text(),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () async {
        await context.navigator.push(
          MaterialPageRoute(
            builder: (_) => LanguageSelectorPage(
              candidates: R.supportedLocales,
              selected: curLocale,
            ),
          ),
        );
      },
    );
  }

  Widget buildCredential(OACredential credential) {
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
      title: i18n.developerOptions.text(),
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
