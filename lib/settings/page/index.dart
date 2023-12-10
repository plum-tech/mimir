import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/network/widgets/entry.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/init.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/session/widgets/scope.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/school/widgets/campus.dart';
import 'package:sit/utils/color.dart';
import 'package:sit/entity/version.dart';
import 'package:rettulf/rettulf.dart';
import 'package:system_theme/system_theme.dart';
import 'package:unicons/unicons.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:locale_names/locale_names.dart';

import '../i18n.dart';
import '../../design/widgets/navigation.dart';

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
        title: i18n.credentials.oaAccount.text(),
        subtitle: credential.account.text(),
        icon: const Icon(Icons.person_rounded),
        path: "/settings/credentials",
      ));
    } else {
      // TODO: i18n
      all.add(ListTile(
        title: "Login".text(),
        subtitle: "Please login".text(),
        leading: const Icon(Icons.person_rounded),
        onTap: () {
          context.go("/login");
        },
      ));
    }
    all.add(const Divider());

    all.add(buildLanguageSelector());
    all.add(buildThemeMode());
    all.add(buildThemeColorPicker());
    all.add(const Divider());

    if (auth.loginStatus != LoginStatus.never) {
      all.add(PageNavigationTile(
        title: i18n.timetable.title.text(),
        icon: const Icon(Icons.calendar_month_outlined),
        path: "/settings/timetable",
      ));
      if (!kIsWeb) {
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
      }
      all.add(const Divider());
    }
    if (!kIsWeb) {
      all.add(PageNavigationTile(
        title: i18n.proxy.title.text(),
        subtitle: i18n.proxy.desc.text(),
        icon: const Icon(Icons.vpn_key),
        path: "/settings/proxy",
      ));
      all.add(const NetworkToolEntryTile());
    }
    if (Settings.isDeveloperMode) {
      all.add(PageNavigationTile(
        title: i18n.dev.title.text(),
        icon: const Icon(Icons.developer_mode_outlined),
        path: "/settings/developer",
      ));
    }
    if (auth.loginStatus != LoginStatus.never) {
      all.add(const ClearCacheTile());
    }
    all.add(const WipeDataTile());
    all.add(const VersionTile());
    return all;
  }

  Widget buildThemeMode() {
    return Settings.theme.listenThemeMode() >>
        (ctx, _) => ListTile(
              leading: switch (Settings.theme.themeMode) {
                ThemeMode.dark => const Icon(Icons.dark_mode),
                ThemeMode.light => const Icon(Icons.light_mode),
                ThemeMode.system => const Icon(Icons.brightness_auto),
              },
              title: i18n.themeModeTitle.text(),
              subtitle: ThemeMode.values
                  .map((mode) => ChoiceChip(
                        label: mode.l10n().text(),
                        selected: Settings.theme.themeMode == mode,
                        onSelected: (value) async {
                          Settings.theme.themeMode = mode;
                          await HapticFeedback.mediumImpact();
                        },
                      ))
                  .toList()
                  .wrap(spacing: 4),
            );
  }

  Widget buildLanguageSelector() {
    final curLocale = context.locale;
    return ListTile(
      leading: const Icon(Icons.translate_rounded),
      title: i18n.language.text(),
      subtitle: curLocale.nativeDisplayLanguageScript.text(),
      trailing: DropdownMenu<Locale>(
        initialSelection: curLocale,
        onSelected: (Locale? locale) async {
          if (locale == null) return;
          await HapticFeedback.mediumImpact();
          if (!mounted) return;
          await context.setLocale(locale);
          final engine = WidgetsFlutterBinding.ensureInitialized();
          engine.performReassemble();
        },
        dropdownMenuEntries: R.supportedLocales
            .map<DropdownMenuEntry<Locale>>(
              (locale) => DropdownMenuEntry<Locale>(
                value: locale,
                label: locale.nativeDisplayLanguageScript,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildThemeColorPicker() {
    // TODO: Better UI
    final selected = Settings.theme.themeColor ?? SystemTheme.accentColor.maybeAccent ?? context.colorScheme.primary;
    final usingSystemDefault = supportsSystemAccentColor && Settings.theme.themeColor == null;

    Future<void> selectNewThemeColor() async {
      final newColor = await showColorPickerDialog(
        context,
        selected,
        enableOpacity: true,
        enableShadesSelection: true,
        enableTonalPalette: true,
        showColorCode: true,
        pickersEnabled: const <ColorPickerType, bool>{
          ColorPickerType.both: true,
          ColorPickerType.primary: false,
          ColorPickerType.accent: false,
          ColorPickerType.custom: true,
          ColorPickerType.wheel: true,
        },
      );
      if (newColor != selected) {
        await HapticFeedback.mediumImpact();
        Settings.theme.themeColor = newColor;
      }
    }

    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: i18n.themeColor.text(),
      subtitle: "#${selected.hexAlpha}".text(),
      onTap: usingSystemDefault ? selectNewThemeColor : null,
      trailing: usingSystemDefault
          ? i18n.fromSystem.text(style: context.textTheme.bodyMedium)
          : [
              IconButton(
                onPressed: () {
                  Settings.theme.themeColor = null;
                },
                icon: const Icon(Icons.delete),
              ),
              FilledCard(
                color: selected,
                clip: Clip.hardEdge,
                child: InkWell(
                  onTap: selectNewThemeColor,
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ].wrap(),
    );
  }
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
    final version = R.currentVersion;
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
      subtitle: "${version.platform.name} ${version.full.toString()}".text(),
      onTap: Settings.isDeveloperMode && clickCount <= 10
          ? null
          : () async {
              if (Settings.isDeveloperMode) return;
              clickCount++;
              if (clickCount >= 10) {
                clickCount = 0;
                Settings.isDeveloperMode = true;
                // TODO: i18n
                context.showSnackBar(content: const Text("Developer mode activated"));
                await HapticFeedback.mediumImpact();
              }
            },
    );
  }
}

class ClearCacheTile extends StatelessWidget {
  const ClearCacheTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: i18n.clearCacheTitle.text(),
      subtitle: i18n.clearCacheDesc.text(),
      leading: const Icon(Icons.folder_delete_outlined),
      onTap: () {
        _onClearCache(context);
      },
    );
  }
}

void _onClearCache(BuildContext context) async {
  final confirm = await context.showRequest(
    title: i18n.clearCacheTitle,
    desc: i18n.clearCacheRequest,
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
      title: i18n.wipeDataTitle.text(),
      subtitle: i18n.wipeDataDesc.text(),
      leading: const Icon(Icons.delete_forever_rounded),
      onTap: () {
        _onWipeData(context);
      },
    );
  }
}

void _onWipeData(BuildContext context) async {
  final confirm = await context.showRequest(
    title: i18n.wipeDataRequest,
    desc: i18n.wipeDataRequestDesc,
    yes: i18n.confirm,
    no: i18n.notNow,
    highlight: true,
    serious: true,
  );
  if (confirm == true) {
    await HiveInit.clear(); // 清除存储
    await Init.initNetwork();
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
