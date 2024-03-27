import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/login/i18n.dart';
import 'package:sit/network/widgets/entry.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/init.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/session/widgets/scope.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/school/widgets/campus.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/dev.dart';
import 'package:locale_names/locale_names.dart';

import '../i18n.dart';
import '../../design/widgets/navigation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final $isDeveloperMode = Dev.listenDevMode();

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
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.title.text(),
          ),
          SliverList.list(
            children: buildEntries(),
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
        title: i18n.oaCredentials.oaAccount.text(),
        subtitle: credential.account.text(),
        leading: const Icon(Icons.person_rounded),
        path: "/settings/credentials",
      ));
    } else {
      const oaLogin = OaLoginI18n();
      all.add(ListTile(
        title: oaLogin.loginOa.text(),
        subtitle: oaLogin.neverLoggedInTip.text(),
        leading: const Icon(Icons.person_rounded),
        onTap: () {
          context.go("/login");
        },
      ));
    }
    all.add(const Divider());

    all.add(PageNavigationTile(
      title: i18n.language.text(),
      subtitle: context.locale.nativeDisplayLanguageScript.text(),
      leading: const Icon(Icons.translate_rounded),
      path: "/settings/language",
    ));
    all.add(buildThemeMode());
    all.add(PageNavigationTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: i18n.themeColor.text(),
      path: "/settings/theme-color",
    ));
    all.add(const Divider());

    if (auth.loginStatus != LoginStatus.never) {
      all.add(PageNavigationTile(
        leading: const Icon(Icons.calendar_month_outlined),
        title: i18n.timetable.title.text(),
        path: "/settings/timetable",
      ));
      if (!kIsWeb) {
        all.add(PageNavigationTile(
          title: i18n.school.title.text(),
          leading: const Icon(Icons.school_outlined),
          path: "/settings/school",
        ));
        all.add(PageNavigationTile(
          title: i18n.life.title.text(),
          leading: const Icon(Icons.spa_outlined),
          path: "/settings/life",
        ));
      }
      all.add(const Divider());
    }
    if (Dev.on) {
      all.add(PageNavigationTile(
        title: i18n.dev.title.text(),
        leading: const Icon(Icons.developer_mode_outlined),
        path: "/settings/developer",
      ));
    }
    if (!kIsWeb) {
      all.add(PageNavigationTile(
        title: i18n.proxy.title.text(),
        subtitle: i18n.proxy.desc.text(),
        leading: const Icon(Icons.vpn_key),
        path: "/settings/proxy",
      ));
      all.add(const NetworkToolEntryTile());
    }
    if (auth.loginStatus != LoginStatus.never) {
      all.add(const ClearCacheTile());
    }
    all.add(const WipeDataTile());
    all.add(PageNavigationTile(
      title: i18n.about.title.text(),
      leading: const Icon(Icons.info),
      path: "/settings/about",
    ));
    all[all.length - 1] = all.last.safeArea(t: false);
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
              isThreeLine: true,
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
    no: i18n.cancel,
    destructive: true,
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

Future<void> _onWipeData(BuildContext context) async {
  final confirm = await context.showRequest(
    title: i18n.wipeDataRequest,
    desc: i18n.wipeDataRequestDesc,
    yes: i18n.confirm,
    no: i18n.cancel,
    destructive: true,
  );
  if (confirm == true) {
    await HiveInit.clear(); // 清除存储
    await Init.initNetwork();
    await Init.initModules();
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
