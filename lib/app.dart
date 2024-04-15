import 'dart:async';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/files.dart';
import 'package:sit/lifecycle.dart';
import 'package:sit/qrcode/handle.dart';
import 'package:sit/r.dart';
import 'package:sit/route.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/update/utils.dart';
import 'package:sit/utils/color.dart';
import 'package:system_theme/system_theme.dart';

final $appLinks = StateProvider((ref) => <Uri>[]);

class MimirApp extends ConsumerStatefulWidget {
  const MimirApp({super.key});

  @override
  ConsumerState<MimirApp> createState() => _MimirAppState();
}

class _MimirAppState extends ConsumerState<MimirApp> {
  final $routingConfig = ValueNotifier(
    Settings.focusTimetable ? buildTimetableFocusRouter() : buildCommonRoutingConfig(),
  );
  late final router = buildRouter($routingConfig);

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      fitSystemScreenshot.init();
    }
  }

  @override
  void dispose() {
    fitSystemScreenshot.release();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // precache timetable background file
    if (Settings.timetable.backgroundImage?.enabled == true) {
      precacheImage(FileImage(Files.timetable.backgroundFile), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final demoMode = ref.watch(Dev.$demoMode);
    final themeColorFromSystem = ref.watch(Settings.theme.$themeColorFromSystem) ?? true;
    ref.listen(Settings.$focusTimetable, (pre, next) {
      $routingConfig.value = next ?? false ? buildTimetableFocusRouter() : buildCommonRoutingConfig();
    });
    final themeColor = themeColorFromSystem
        ? SystemTheme.accentColor.maybeAccent
        : ref.watch(Settings.theme.$themeColor) ?? SystemTheme.accentColor.maybeAccent;

    ThemeData bakeTheme(ThemeData origin) {
      return origin.copyWith(
        platform: R.debugCupertino ? TargetPlatform.iOS : null,
        colorScheme: themeColor == null
            ? null
            : ColorScheme.fromSeed(
                seedColor: themeColor,
                brightness: origin.brightness,
              ),
        visualDensity: VisualDensity.comfortable,
        splashFactory: InkSparkle.splashFactory,
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
        child: child ?? const SizedBox(),
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
  StreamSubscription? $appLink;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Future.delayed(Duration.zero).then((value) async {
        await checkAppUpdate(
          context: $key.currentContext!,
          delayAtLeast: const Duration(milliseconds: 3000),
          manually: false,
        );
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      $appLink = AppLinks().allUriLinkStream.listen((uri) async {
        ref.read($appLinks.notifier).state = [...ref.read($appLinks), uri];
        final navigateCtx = $key.currentContext;
        if (navigateCtx == null) return;
        await onHandleQrCodeUriData(context: navigateCtx, qrCodeData: uri);
      });
    });
  }

  @override
  void dispose() {
    $appLink?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
