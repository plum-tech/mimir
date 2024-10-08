import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/agreements/entity/agreements.dart';
import 'package:mimir/agreements/page/privacy_policy.dart';
import 'package:mimir/backend/stats/utils/stats.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/files.dart';
import 'package:mimir/intent/file_type/handle.dart';
import 'package:mimir/lifecycle.dart';
import 'package:mimir/intent/deep_link/handle.dart';
import 'package:mimir/platform/quick_action.dart';
import 'package:mimir/r.dart';
import 'package:mimir/route.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/backend/update/utils.dart';
import 'package:mimir/storage/objectbox/init.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/utils/sync.dart';
import 'package:mimir/utils/color.dart';
import 'package:mimir/utils/error.dart';
import 'package:objectbox/objectbox.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:system_theme/system_theme.dart';
import 'package:universal_platform/universal_platform.dart';

final $appLinks = StateProvider((ref) => <({Uri uri, DateTime ts})>[]);
final $intentFiles = StateProvider((ref) => <SharedMediaFile>[]);

class MimirApp extends ConsumerStatefulWidget {
  const MimirApp({super.key});

  @override
  ConsumerState<MimirApp> createState() => _MimirAppState();
}

class _MimirAppState extends ConsumerState<MimirApp> {
  final $routingConfig = ValueNotifier(
    Settings.timetable.focusTimetable ? buildTimetableFocusRouter() : buildCommonRoutingConfig(),
  );
  late final router = buildRouter($routingConfig);
  StreamSubscription? intentSub;
  StreamSubscription? $appLink;

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
      );
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    if (!kIsWeb) {
      fitSystemScreenshot.init();
    }

    router.routeInformationProvider.addListener(onRouteChanged);
    // router.routerDelegate.addListener(onChanged);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      $appLink = AppLinks().uriLinkStream.listen(handleUriLink);
    });
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      // Listen to media sharing coming from outside the app while the app is in the memory.
      intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((list) async {
        ref.read($intentFiles.notifier).state = [
          ...ref.read($intentFiles),
          ...list,
        ];
        await handleFileIntents(list);
      }, onError: (error) {
        debugPrintError(error);
      });

      // Get the media sharing coming from outside the app while the app is closed.
      ReceiveSharingIntent.instance.getInitialMedia().then((list) async {
        ref.read($intentFiles.notifier).state = [
          ...ref.read($intentFiles),
          ...list,
        ];
        await handleFileIntents(list);
        if (UniversalPlatform.isIOS) {
          await Future.wait(list.map((file) => File(file.path).delete(recursive: false)));
        }
        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
    }
  }

  void onRouteChanged() {
    final info = router.routeInformationProvider.value;
    Stats.route(info.uri);
    // final state = info.state;
    // if(state is RouteInformationState){
    //   debugPrint("${state.type}");
    // }
  }

  void onChanged() {
    final config = router.routerDelegate.currentConfiguration;
    debugPrint("${config.uri}");
  }

  @override
  void dispose() {
    $appLink?.cancel();
    fitSystemScreenshot.release();
    intentSub?.cancel();
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demoMode = ref.watch(Dev.$demoMode);
    final themeColorFromSystem = ref.watch(Settings.theme.$themeColorFromSystem) ?? true;
    ref.listen(Settings.timetable.$focusTimetable, (pre, next) {
      $routingConfig.value = next ? buildTimetableFocusRouter() : buildCommonRoutingConfig();
    });
    final themeColor = themeColorFromSystem
        ? SystemTheme.accentColor.maybeAccent
        : ref.watch(Settings.theme.$themeColor) ?? SystemTheme.accentColor.maybeAccent;

    ThemeData bakeTheme(ThemeData origin) {
      return origin.copyWith(
        platform: R.debugCupertino ? TargetPlatform.iOS : null,
        menuTheme: MenuThemeData(
          style: (origin.menuTheme.style ?? const MenuStyle()).copyWith(
            shape: WidgetStatePropertyAll<OutlinedBorder?>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
        ),
        colorScheme: themeColor == null
            ? null
            : ColorScheme.fromSeed(
                seedColor: themeColor,
                brightness: origin.brightness,
              ),
        visualDensity: VisualDensity.comfortable,
        splashFactory: kIsWeb ? null : InkSparkle.splashFactory,
        navigationBarTheme: const NavigationBarThemeData(
          height: 60,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
            TargetPlatform.windows: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
          },
        ),
      );
    }

    return MaterialApp.router(
      title: R.appName,
      onGenerateTitle: (ctx) => "appName".tr(),
      routerConfig: router,
      debugShowCheckedModeBanner: !demoMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: ref.watch(Settings.theme.$themeMode),
      theme: bakeTheme(ThemeData.light()),
      darkTheme: bakeTheme(ThemeData.dark()),
      builder: (ctx, child) => _PostServiceRunner(
        key: const ValueKey("Post service runner"),
        child: child ?? const SizedBox.shrink(),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown
        },
      ),
    );
  }

  Future<void> handleUriLink(Uri uri) async {
    ref.read($appLinks.notifier).state = [...ref.read($appLinks), (uri: uri, ts: DateTime.now())];
    final navigateCtx = $key.currentContext;
    if (navigateCtx == null) return;
    if (!kIsWeb) {
      final maybePath = Uri.decodeFull(uri.toString());
      if (uri.scheme == "file") {
        await onHandleFilePath(context: navigateCtx, path: maybePath);
        return;
      } else {
        final isFile = await File(maybePath).exists();
        if (isFile) {
          if (!navigateCtx.mounted) return;
          await onHandleFilePath(context: navigateCtx, path: maybePath);
          return;
        }
      }
    }
    if (!navigateCtx.mounted) return;
    await onHandleDeepLink(context: navigateCtx, deepLink: uri);
  }
}

class _PostServiceRunner extends ConsumerStatefulWidget {
  final Widget child;

  const _PostServiceRunner({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<_PostServiceRunner> createState() => _PostServiceRunnerState();
}

class _PostServiceRunnerState extends ConsumerState<_PostServiceRunner> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: onResume,
    );
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await checkAppUpdate(
          context: $key.currentContext!,
          delayAtLeast: const Duration(milliseconds: 3000),
          manually: false,
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await tryAutoSyncTimetable();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final navigateCtx = $key.currentContext;
      if (navigateCtx == null) return;
      final accepted = ref.read(Settings.agreements.$basicAcceptanceOf(AgreementVersion.current));
      if (accepted == true) return;
      await AgreementsAcceptanceSheet.show(navigateCtx);
    });
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      initQuickActions();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (kDebugMode && Admin.isAvailable()) {
        final admin = Admin(ObjectBoxInit.store);
        ObjectBoxInit.objectBoxAdmin = admin;
        debugPrint("ObjectBox Admin running at port ${admin.port}.");
      }
    });
  }

  @override
  void dispose() {
    _listener.dispose();
    ObjectBoxInit.objectBoxAdmin?.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheTimetableBackground();
    super.didChangeDependencies();
  }

  Future<void> onResume() async {
    await precacheTimetableBackground();
  }

  Future<void> precacheTimetableBackground() async {
    // precache timetable background file
    final timetableBk = Settings.timetable.backgroundImage;
    if (timetableBk != null && timetableBk.enabled) {
      if (kIsWeb) {
        await precacheImage(NetworkImage(timetableBk.path), context);
      } else {
        await precacheImage(FileImage(Files.timetable.backgroundFile), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(CredentialsInit.storage.oa.$credentials, (pre, next) async {
      await initQuickActions();
    });
    return widget.child;
  }

  Future<void> tryAutoSyncTimetable() async {
    final navigateCtx = $key.currentContext;
    if (navigateCtx == null) return;
    if (!Settings.timetable.autoSyncTimetable) return;
    final selected = TimetableInit.storage.timetable.selectedRow;
    if (selected == null) return;
    if (canAutoSyncTimetable(selected)) {
      try {
        final merged = await autoSyncTimetable(navigateCtx, selected);
        if (merged != null) {
          TimetableInit.storage.timetable[selected.uuid] = merged;
        }
      } catch (error, stackTrace) {
        debugPrintError(error, stackTrace);
      }
    }
  }
}

Future<void> handleFileIntents(List<SharedMediaFile> files) async {
  final navigateCtx = $key.currentContext;
  if (navigateCtx == null) return;
  for (final file in files) {
    // ignore the url intent from the this app
    if (file.type == SharedMediaType.url) {
      final uri = Uri.tryParse(file.path);
      if (uri != null && canHandleDeepLink(deepLink: uri)) continue;
    }
    if (!navigateCtx.mounted) return;
    await onHandleFilePath(context: navigateCtx, path: file.path);
  }
}
