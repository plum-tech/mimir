import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/update/entity/channel.dart';
import 'package:mimir/design/adaptive/swipe.dart';
import 'package:mimir/intent/qrcode/page/view.dart';
import 'package:mimir/login/x.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/storage/objectbox/init.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/service/school.demo.dart';
import 'package:mimir/app.dart';
import 'package:mimir/backend/init.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/entity/login_status.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/credentials/utils.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widget/expansion_tile.dart';
import 'package:mimir/game/widget/party_popper.dart';
import 'package:mimir/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/login/utils.dart';
import 'package:mimir/intent/deep_link/handle.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/design/widget/navigation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/widget/inapp_webview/page.dart';
import 'package:universal_platform/universal_platform.dart';
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
    final credentials = ref.watch(CredentialsInit.storage.oa.$credentials);
    final demoMode = ref.watch(Dev.$demoMode);
    final deviceInfo = R.deviceInfo;
    final objectboxAdmin = ObjectBoxInit.objectBoxAdmin;
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
              buildMimirBetaApiToggle(),
              PageNavigationTile(
                title: i18n.dev.localStorage.text(),
                subtitle: i18n.dev.localStorageDesc.text(),
                leading: const Icon(Icons.storage),
                path: "/settings/developer/local-storage",
              ),
              buildReload(),
              const AddDemoTimetableTile(),
              const UpdateChannelSwitcherTile(),
              const DebugExpenseUserOverrideTile(),
              if (credentials != null)
                SwitchOaUserTile(
                  currentCredentials: credentials,
                ),
              if (demoMode && credentials != R.demoModeOaCredential && credentials != R.demoModeOaCredentialWithoutGame)
                ListTile(
                  leading: const Icon(Icons.adb),
                  title: "Login demo account".text(),
                  trailing: const Icon(Icons.login),
                  onTap: () async {
                    Settings.lastSignature ??= "Liplum";
                    CredentialsInit.storage.oa.credentials = R.demoModeOaCredential;
                    CredentialsInit.storage.oa.loginStatus = OaLoginStatus.validated;
                    CredentialsInit.storage.oa.lastAuthTime = DateTime.now();
                    CredentialsInit.storage.oa.userType = OaUserType.undergraduate;
                    await Init.initModules();
                    if (!context.mounted) return;
                    context.go("/");
                  },
                ),
              if (demoMode && credentials != R.demoModeOaCredentialWithoutGame)
                ListTile(
                  leading: const Icon(Icons.adb),
                  title: "Login demo account off games".text(),
                  subtitle: "Without games".text(),
                  trailing: const Icon(Icons.login),
                  onTap: () async {
                    Settings.lastSignature ??= "Liplum";
                    CredentialsInit.storage.oa.credentials = R.demoModeOaCredentialWithoutGame;
                    CredentialsInit.storage.oa.loginStatus = OaLoginStatus.validated;
                    CredentialsInit.storage.oa.lastAuthTime = DateTime.now();
                    CredentialsInit.storage.oa.userType = OaUserType.undergraduate;
                    await Init.initModules();
                    if (!context.mounted) return;
                    context.go("/");
                  },
                ),
              if (Admin.isAvailable() && objectboxAdmin != null && !objectboxAdmin.isClosed())
                ListTile(
                  title: "Open Objectbox Admin".text(),
                  subtitle: "http://localhost:${objectboxAdmin.port}/index.html".text(),
                  trailing: const Icon(Icons.open_in_browser),
                  onTap: () async {
                    await guardLaunchUrlString(context, "http://localhost:${objectboxAdmin.port}/index.html");
                  },
                ),
              const ReceivedDeepLinksTile(),
              const DebugGoRouteTile(),
              const DebugWebViewTile(),
              const DebugDeepLinkTile(),
              const QrCodeCreatorTile(),
              if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) const GoInAppWebviewTile(),
              if (deviceInfo != null)
                ListTile(
                  title: "Device info".text(),
                  trailing: Icon(context.icons.rightChevron),
                  onTap: () {
                    context.showSheet((ctx) => DeviceInfoPage(
                          info: deviceInfo,
                        ));
                  },
                ),
              if (!kIsWeb) ...[
                DebugFetchVersionTile(
                  title: "Latest release version".text(),
                  fetch: () async {
                    final info = await BackendInit.update.getLatestVersionInfo(channel: UpdateChannel.release);
                    return info.version.toString();
                  },
                ),
                DebugFetchVersionTile(
                  title: "Latest preview version".text(),
                  fetch: () async {
                    final info = await BackendInit.update.getLatestVersionInfo(channel: UpdateChannel.preview);
                    return info.version.toString();
                  },
                ),
              ],
              buildPartyPopper(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildPartyPopper() {
    return ListTile(
      leading: "🎉".text(style: context.textTheme.headlineLarge),
      title: "Party popper 🎉".text(),
      subtitle: "Tap me!".text(),
      trailing: Icon(context.icons.rightChevron),
      onTap: () {
        context.showSheet((ctx) => Scaffold(
              body: [
                const VictoryPartyPopper(
                  pop: true,
                ),
              ].stack(),
            ));
      },
    );
  }

  Widget buildDevModeToggle() {
    final on = ref.watch(Dev.$on);
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.developer_mode_outlined),
      title: i18n.dev.devMode.text(),
      value: on,
      onChanged: (newV) {
        ref.read(Dev.$on.notifier).set(newV);
      },
    );
  }

  Widget buildMimirBetaApiToggle() {
    final on = ref.watch(Dev.$betaBackendAPI);
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.developer_board),
      title: "Beta backend API".text(),
      subtitle: "Switch available features to beta backend".text(),
      value: on,
      onChanged: (newV) {
        ref.read(Dev.$betaBackendAPI.notifier).set(newV);
      },
    );
  }

  Widget buildDemoModeToggle() {
    final demoMode = ref.watch(Dev.$demoMode);
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.adb),
      title: i18n.dev.demoMode.text(),
      value: demoMode,
      onChanged: (newV) async {
        ref.read(Dev.$demoMode.notifier).set(newV);
        await Init.initModules();
      },
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

class UpdateChannelSwitcherTile extends ConsumerWidget {
  const UpdateChannelSwitcherTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(Settings.update.$updateChannel);
    return ListTile(
      leading: const Icon(Icons.update),
      title: "Update channel".text(),
      subtitle: UpdateChannel.values
          .map((channel) => ChoiceChip(
                label: channel.name.text(),
                selected: selected == channel,
                onSelected: (_) {
                  ref.read(Settings.update.$updateChannel.notifier).set(channel);
                },
              ))
          .toList()
          .wrap(spacing: 4),
    );
  }
}

class QrCodeCreatorTile extends StatelessWidget {
  const QrCodeCreatorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInputActionTile(
      leading: const Icon(Icons.route_outlined),
      title: "Show QR code".text(),
      canSubmit: (content) => content.isNotEmpty,
      hintText: "${R.scheme}://go/settings",
      onSubmit: (content) async {
        await context.showSheet((ctx) => QrCodePage(data: content));
        return true;
      },
    );
  }
}

class ReceivedDeepLinksTile extends ConsumerWidget {
  const ReceivedDeepLinksTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLinks = ref.watch($appLinks);
    return AnimatedExpansionTile(
      leading: const Icon(Icons.link),
      title: "Deep links".text(),
      children: appLinks
          .map((uri) => ListTile(
                title: context.formatYmdhmsNum(uri.ts).text(),
                subtitle: Uri.decodeFull(uri.uri.toString()).text(),
              ))
          .toList(),
    );
  }
}

class AddDemoTimetableTile extends StatelessWidget {
  const AddDemoTimetableTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: "Add demo timetable".text(),
      leading: const Icon(Icons.calendar_month),
      trailing: IconButton.filledTonal(
        icon: Icon(context.icons.add),
        onPressed: () async {
          final timetable = await const DemoTimetableService().fetchUgTimetable(estimateSemesterInfo());
          TimetableInit.storage.timetable.add(timetable);
          if (!context.mounted) return;
          context.showTip(
            desc: "Demo timetable was added",
            primary: i18n.ok,
          );
        },
      ),
    );
  }
}

class DebugGoRouteTile extends StatelessWidget {
  const DebugGoRouteTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInputActionTile(
      leading: const Icon(Icons.route_outlined),
      title: "Go route".text(),
      canSubmit: (route) => route.isNotEmpty,
      hintText: "/anyway",
      onSubmit: (route) {
        if (!route.startsWith("/")) {
          route = "/$route";
        }
        context.push(route);
        return true;
      },
    );
  }
}

class DebugWebViewTile extends StatelessWidget {
  const DebugWebViewTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInputActionTile(
      leading: const Icon(Icons.web),
      title: "Type URL".text(),
      hintText: R.websiteUri.toString(),
      canSubmit: (url) => url.isEmpty || Uri.tryParse(url) != null,
      onSubmit: (url) {
        if (url.isEmpty) {
          url = R.websiteUri.toString();
        }
        var uri = Uri.tryParse(url);
        if (uri == null) return false;
        if (uri.scheme.isEmpty) {
          uri = uri.replace(scheme: "https");
        }
        guardLaunchUrl(context, uri);
        return true;
      },
    );
  }
}

class DebugDeepLinkTile extends StatelessWidget {
  const DebugDeepLinkTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInputActionTile(
      leading: const Icon(Icons.link),
      title: "Deep Link".text(),
      hintText: "${R.scheme}://",
      canSubmit: (url) {
        if (url.isEmpty) return false;
        final uri = Uri.tryParse(url);
        if (uri == null) return false;
        if (!uri.isScheme(R.scheme)) return false;
        return canHandleDeepLink(deepLink: uri);
      },
      onSubmit: (uriString) async {
        final uri = Uri.tryParse(uriString);
        if (uri == null) return false;
        return await onHandleDeepLink(context: context, deepLink: uri) == DeepLinkHandleResult.success;
      },
    );
  }
}

class TextInputActionTile extends StatefulWidget {
  final Widget? title;
  final Widget? leading;
  final String? hintText;

  /// return true to consume the text
  final FutureOr<bool> Function(String text) onSubmit;
  final bool Function(String text)? canSubmit;

  const TextInputActionTile({
    super.key,
    this.title,
    this.leading,
    required this.onSubmit,
    this.canSubmit,
    this.hintText,
  });

  @override
  State<TextInputActionTile> createState() => _TextInputActionTileState();
}

class _TextInputActionTileState extends State<TextInputActionTile> {
  final $text = TextEditingController();

  @override
  void dispose() {
    $text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = widget.canSubmit;
    return ListTile(
      isThreeLine: true,
      leading: widget.leading,
      title: widget.title,
      subtitle: TextField(
        controller: $text,
        textInputAction: TextInputAction.go,
        onSubmitted: (text) {
          if (widget.canSubmit?.call(text) != false) {
            onSubmit();
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
      ),
      trailing: $text >>
          (ctx, text) => PlatformIconButton(
                onPressed: canSubmit == null
                    ? onSubmit
                    : canSubmit(text.text)
                        ? onSubmit
                        : null,
                icon: const Icon(Icons.arrow_forward),
              ),
    );
  }

  Future<void> onSubmit() async {
    final result = await widget.onSubmit($text.text);
    if (result) {
      $text.clear();
    }
  }
}

class SwitchOaUserTile extends StatefulWidget {
  final Credential currentCredentials;

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
        ...credentialsList.map(buildCredentialsHistoryTile).map((e) => e.padOnly(l: 32)),
        buildLoginNewTile().padOnly(l: 32),
      ],
    );
  }

  Widget buildCredentialsHistoryTile(Credential credentials) {
    final isCurrent = credentials == widget.currentCredentials;
    return WithSwipeAction(
      right: SwipeAction.delete(
        icon: context.icons.delete,
        action: () async {
          final former = Dev.getSavedOaCredentialsList() ?? [];
          former.remove(credentials);
          await Dev.setSavedOaCredentialsList(former);
        },
      ),
      childKey: ValueKey(credentials),
      child: ListTile(
        leading: Icon(context.icons.accountCircle),
        title: credentials.account.text(),
        subtitle: isCurrent ? "Current user".text() : estimateOaUserType(credentials.account)?.l10n().text(),
        trailing: isCurrent
            ? null
            : [
                IconButton.filledTonal(
                  icon: const Icon(Icons.switch_account),
                  onPressed: () async {
                    CredentialsInit.storage.oa.credentials = credentials;
                    CredentialsInit.storage.oa.loginStatus = OaLoginStatus.everLogin;
                    CredentialsInit.storage.oa.lastAuthTime = DateTime.now();
                    CredentialsInit.storage.oa.userType = estimateOaUserType(credentials.account) ?? OaUserType.none;
                  },
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.login),
                  onPressed: () async {
                    await loginWith(credentials);
                  },
                ),
              ].row(mas: MainAxisSize.min),
        enabled: !isCurrent,
        onLongPress: () async {
          context.showSnackBar(content: i18n.copyTipOf(i18n.oa.oaAccount).text());
          await Clipboard.setData(ClipboardData(text: credentials.account));
        },
      ),
    );
  }

  Widget buildLoginNewTile() {
    return ListTile(
      title: "New account".text(),
      trailing: [
        IconButton.filledTonal(
          icon: Icon(context.icons.add),
          onPressed: () async {
            final credentials = await Editor.showAnyEditor(
              context,
              initial: const Credential(account: "", password: ""),
            );
            if (credentials == null) return;
            final old = CredentialsInit.storage.oa.credentials;
            await recordNewCredentials(credentials, old: old);
            CredentialsInit.storage.oa.credentials = credentials;
            CredentialsInit.storage.oa.loginStatus = OaLoginStatus.everLogin;
            CredentialsInit.storage.oa.lastAuthTime = DateTime.now();
            CredentialsInit.storage.oa.userType = estimateOaUserType(credentials.account) ?? OaUserType.none;
          },
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.login),
          onPressed: () async {
            final credentials = await Editor.showAnyEditor(
              context,
              initial: const Credential(account: "", password: ""),
            );
            if (credentials == null || credentials.account.trim().isEmpty || credentials.password.trim().isEmpty) {
              return;
            }
            await loginWith(credentials);
          },
        ),
      ].row(mas: MainAxisSize.min),
    );
  }

  Future<void> recordNewCredentials(Credential credentials, {Credential? old}) async {
    final List<Credential> newCredentials = [
      ...Dev.getSavedOaCredentialsList() ?? [],
      credentials,
    ];
    if (old != null && !newCredentials.any((c) => c.account == old.account)) {
      newCredentials.add(old);
    }
    await Dev.setSavedOaCredentialsList(newCredentials);
  }

  Future<void> loginWith(Credential credentials) async {
    setState(() => isLoggingIn = true);
    try {
      final old = CredentialsInit.storage.oa.credentials;
      await Init.schoolCookieJar.deleteAll();
      await XLogin.login(credentials);
      await recordNewCredentials(credentials, old: old);
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

class GoInAppWebviewTile extends ConsumerWidget {
  const GoInAppWebviewTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextInputActionTile(
      leading: const Icon(Icons.route_outlined),
      title: "In-app Webview".text(),
      canSubmit: (url) => url.isEmpty || Uri.tryParse(url) != null,
      hintText: R.websiteUri.toString(),
      onSubmit: (url) {
        if (url.isEmpty) {
          url = R.websiteUri.toString();
        }
        var uri = Uri.tryParse(url);
        if (uri == null) return false;
        if (uri.scheme.isEmpty) {
          uri = uri.replace(scheme: "https");
        }
        context.navigator.push(MaterialPageRoute(
          builder: (ctx) => InAppWebViewPage(
            initialUri: WebUri.uri(uri!),
            cookieJar: Init.cookieJar,
          ),
        ));
        return true;
      },
    );
  }
}

class DebugFetchVersionTile extends StatefulWidget {
  final Widget? title;
  final Widget? leading;
  final Future<String> Function() fetch;

  const DebugFetchVersionTile({
    super.key,
    this.title,
    this.leading,
    required this.fetch,
  });

  @override
  State<DebugFetchVersionTile> createState() => _DebugFetchVersionTileState();
}

class _DebugFetchVersionTileState extends State<DebugFetchVersionTile> with AutomaticKeepAliveClientMixin {
  String? version;
  var isFetching = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      isFetching = true;
    });
    final v = await widget.fetch();
    if (!mounted) return;
    setState(() {
      version = v;
      isFetching = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListTile(
      title: widget.title,
      leading: widget.leading,
      subtitle: version?.text(),
      trailing: isFetching ? const CircularProgressIndicator.adaptive() : null,
    );
  }
}

class DeviceInfoPage extends ConsumerStatefulWidget {
  final BaseDeviceInfo info;

  const DeviceInfoPage({
    super.key,
    required this.info,
  });

  @override
  ConsumerState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends ConsumerState<DeviceInfoPage> {
  @override
  Widget build(BuildContext context) {
    const encoder = JsonEncoder.withIndent("  ");
    final json = encoder.convert(widget.info.data);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          json.text().scrolled().padAll(8).sliver(),
        ],
      ),
    );
  }

  List<Widget> buildWidgets(BaseDeviceInfo info) {
    if (info is AndroidDeviceInfo) {
      info.device;
    } else if (info is IosDeviceInfo) {
      info.model;
    } else if (info is WindowsDeviceInfo) {
      info.productName;
    } else if (info is MacOsDeviceInfo) {
      info.model;
    } else if (info is WebBrowserInfo) {
    } else if (info is LinuxDeviceInfo) {
      info.name;
    }
    return [];
  }
}
