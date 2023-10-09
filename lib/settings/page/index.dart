import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credential/entity/login_status.dart';
import 'package:sit/credential/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/global/init.dart';
import 'package:sit/hive/init.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/session/widgets/scope.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/settings/widgets/campus.dart';
import 'package:sit/version.dart';
import 'package:rettulf/rettulf.dart';
import 'package:unicons/unicons.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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
        title: i18n.credential.oaAccount.text(),
        subtitle: credential.account.text(),
        icon: const Icon(Icons.person_rounded),
        path: "/settings/credentials",
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

  Widget buildThemeMode() {
    return ListTile(
      leading: switch (Settings.theme.themeMode) {
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
        selected: <ThemeMode>{Settings.theme.themeMode},
        onSelectionChanged: (newSelection) async {
          setState(() {
            Settings.theme.themeMode = newSelection.first;
          });
          await HapticFeedback.mediumImpact();
        },
      ),
    );
  }

  Widget buildLanguageSelector() {
    final curLocale = context.locale;
    return ListTile(
      leading: const Icon(Icons.translate_rounded),
      title: i18n.language.title.text(),
      subtitle: i18n.language.languageOf(curLocale).text(),
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
                label: i18n.language.languageOf(locale),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildThemeColorPicker() {
    final selected = Settings.theme.themeColor ?? context.colorScheme.primary;
    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: i18n.themeColor.text(),
      subtitle: "0x${selected.hexAlpha}".text(),
      trailing: IconButton(
        icon: const Icon(Icons.colorize),
        onPressed: () async {
          final color = await context.show$Sheet$<Color>((_) => ThemeColorPicker(initialColor: selected));
          if (color != null) {
            await HapticFeedback.mediumImpact();
            Settings.theme.themeColor = color;
          }
        },
      ),
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
      // subtitle: "${version.platform.name} master-231008A".text(),
      subtitle: "${version.platform.name} ${version.full?.toString() ?? i18n.unknown}".text(),
      onTap: Settings.isDeveloperMode && clickCount <= 10
          ? null
          : () async {
              if (Settings.isDeveloperMode) return;
              clickCount++;
              if (clickCount >= 10) {
                clickCount = 0;
                Settings.isDeveloperMode = true;
                // TODO: i18n
                context.showSnackBar(const Text("Developer mode is on."));
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

class ThemeColorPicker extends StatefulWidget {
  final Color initialColor;

  const ThemeColorPicker({
    super.key,
    required this.initialColor,
  });

  @override
  State<ThemeColorPicker> createState() => _ThemeColorPickerState();
}

class _ThemeColorPickerState extends State<ThemeColorPicker> {
  late Color selected = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Select color".text(),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.navigator.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.navigator.pop(selected);
            },
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        child: ColorPicker(
          color: selected,
          onColorChanged: (color) {
            setState(() => selected = color);
          },
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.both: false,
            ColorPickerType.primary: true,
            ColorPickerType.accent: true,
            ColorPickerType.bw: false,
            ColorPickerType.custom: false,
            ColorPickerType.wheel: true,
          },
          width: 44,
          height: 44,
          borderRadius: 22,
          showMaterialName: true,
          subheading: Text(
            'Select color shade',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}
