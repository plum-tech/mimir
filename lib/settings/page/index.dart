import 'dart:convert';
import 'dart:io';

import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/design/user_widgets/dialog.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/route.dart';
import 'package:mimir/storage/init.dart';
import 'package:mimir/storage/storage/develop.dart';
import 'package:mimir/util/file.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/util/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../storage/page/editor.dart';
import '../../storage/storage/pref.dart';
import 'home_rearrange.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _passwordController = TextEditingController();
  static final String currentVersion =
      'v${Initializer.currentVersion.version} on ${Initializer.currentVersion.platform}';

  Future<void> _onChangeBgImage() async {
    final saveToPath = '${(await getApplicationDocumentsDirectory()).path}/kite1/background';

    if (UniversalPlatform.isDesktop) {
      String? srcPath = await FileUtils.pickImageByFilePicker();
      if (srcPath == null) return;
      await File(srcPath).copy(saveToPath);
    } else {
      XFile? image = await FileUtils.pickImageByImagePicker();
      await image?.saveTo(saveToPath);
    }
    Kv.home.background = saveToPath;
    Global.eventBus.emit(EventNameConstants.onBackgroundChange);
  }

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

  void _gotoWelcome(BuildContext ctx) {
    final navigator = ctx.navigator;
    while (navigator.canPop()) {
      navigator.pop();
    }
    navigator.pushReplacementNamed(RouteTable.welcome);

    Log.info('重启成功');
  }

  void _onClearStorage(BuildContext context) async {
    final confirm = await context.showRequest(
      title: i18n.settingsWipeDataRequest,
      desc: i18n.settingsWipeDataDesc,
      yes: i18n.confirm,
      no: i18n.notNow,
      highlight: true,
      serious: true,
    );
    if (confirm == true) {
      await HiveBoxInit.clear(); // 清除存储
      await Initializer.init();
      FireOn.global(CredentialChangeEvent());
      if (!mounted) return;
      _gotoWelcome(context);
    }
  }

  void _onClearCache(BuildContext context) async {
    final confirm = await context.showRequest(
      title: i18n.settingsClearCache,
      desc: i18n.settingsClearCacheDesc,
      yes: i18n.confirm,
      no: i18n.notNow,
      highlight: true,
      serious: true,
    );
    if (confirm == true) {
      await HiveBoxInit.clearCache(); // 清除存储
    }
  }

  _buildLanguagePrefSelector(BuildContext ctx) {
    final Locale curLocale = Lang.getOrSetCurrentLocale(Localizations.localeOf(ctx));

    return DropDownSettingsTile<String>(
      title: i18n.settingsLanguage,
      subtitle: i18n.settingsLanguageSub,
      leading: const Icon(Icons.translate_rounded),
      settingKey: PrefKey.locale,
      values: {
        jsonEncode(Lang.enLocale.toJson()): i18n.language_en,
        jsonEncode(Lang.zhLocale.toJson()): i18n.language_zh,
        jsonEncode(Lang.zhTwLocale.toJson()): i18n.language_zh_TW,
      },
      selected: jsonEncode(curLocale.toJson()),
      onChange: (value) {
        Future.delayed(Duration.zero, () => Phoenix.rebirth(ctx));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final oaCredential = Auth.oaCredential;
    _passwordController.text = oaCredential?.password ?? '';
    return SettingsScreen(title: i18n.settingsTitle, children: [
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
      // TODO: A new personalize system
      SettingsGroup(
        title: i18n.homepage,
        children: <Widget>[
          RadioSettingsTile<int>(
            title: i18n.settingsHomepageWallpaperMode,
            settingKey: HomeKeyKeys.backgroundMode,
            values: <int, String>{
              1: i18n.realtimeWeather,
              2: i18n.staticPicture,
            },
            selected: Kv.home.backgroundMode,
            // TODO: Kv may return a unavailable value
            onChange: (value) async {
              final backgroundPath = Kv.home.background;
              if (backgroundPath != null) {
                if (await File(backgroundPath).exists()) {
                  Kv.home.backgroundMode = value;
                  Global.eventBus.emit(EventNameConstants.onBackgroundChange);
                }
              }
            },
          ),
          DropDownSettingsTile<int>(
            title: i18n.settingsCampus,
            subtitle: i18n.settingsCampusSub,
            leading: const Icon(Icons.location_on),
            settingKey: HomeKeyKeys.campus,
            values: <int, String>{
              1: i18n.fengxian,
              2: i18n.xuhui,
            },
            selected: Kv.home.campus,
            onChange: (value) {
              Kv.home.campus = value;
              Global.eventBus.emit(EventNameConstants.onCampusChange);
            },
          ),
          SimpleSettingsTile(
              title: i18n.settingsWallpaper,
              subtitle: i18n.settingsWallpaperSub,
              leading: const Icon(Icons.photo_size_select_actual_outlined),
              onTap: _onChangeBgImage),
          SimpleSettingsTile(
            title: i18n.settingsHomepageRearrange,
            subtitle: i18n.settingsHomepageRearrangeSub,
            leading: const Icon(Icons.menu),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeRearrangePage())),
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
                  Navigator.pushNamed(context, RouteTable.networkTool);
                }),
          ],
        ),
      ]),
      // Account
      SettingsGroup(
        title: i18n.account,
        children: <Widget>[
          if (oaCredential != null)
            SimpleSettingsTile(
              title: i18n.studentID,
              subtitle: oaCredential.account,
              leading: const Icon(Icons.person_rounded),
              onTap: () {
                // Copy the student ID to clipboard
                Clipboard.setData(ClipboardData(text: oaCredential.account));
                context.showSnackBar(i18n.studentIdCopy2ClipboardTip.text());
              },
            ),
          if (oaCredential != null)
            ModalSettingsTile(
              title: i18n.settingsChangeOaPwd,
              subtitle: i18n.settingsChangeOaPwdSub,
              leading: const Icon(Icons.lock),
              showConfirmation: true,
              onConfirm: () {
                Auth.oaCredential = oaCredential.copyWith(
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
      // Data Management
      SettingsGroup(title: i18n.dataManagement, children: <Widget>[
        SimpleSettingsTile(
            title: i18n.settingsWipeData,
            leading: const Icon(Icons.delete_forever_rounded),
            subtitle: i18n.settingsWipeDataSub,
            onTap: () => _onClearStorage(context)),
        SimpleSettingsTile(
            title: i18n.settingsClearCache,
            leading: const Icon(Icons.folder_delete_outlined),
            subtitle: i18n.settingsClearCacheSub,
            onTap: () => _onClearCache(context)),
      ]),
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
          SimpleSettingsTile(
            title: i18n.settingsLocalStorage,
            subtitle: i18n.settingsLocalStorageSub,
            leading: const Icon(Icons.storage),
            onTap: () => context.navigator.push(MaterialPageRoute(builder: (context) => const LocalStoragePage())),
          ),
          if (kDebugMode)
            SimpleSettingsTile(
              title: i18n.settingsReload,
              subtitle: i18n.settingsReloadSub,
              leading: const Icon(Icons.refresh_rounded),
              onTap: () async {
                await Initializer.init();
                context.navigator.pop();
              },
            )
        ],
      ),
      SettingsGroup(title: i18n.status, children: <Widget>[
        SimpleSettingsTile(
          title: i18n.currentVersion,
          subtitle: currentVersion,
          leading: const Icon(Icons.settings_applications),
        ),
      ])
    ]);
  }
}
