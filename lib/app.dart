import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/r.dart';
import 'package:sit/route.dart';
import 'package:sit/session/widgets/scope.dart';
import 'package:sit/settings/settings.dart';

class MimirApp extends StatefulWidget {
  const MimirApp({super.key});

  @override
  State<MimirApp> createState() => _MimirAppState();
}

class _MimirAppState extends State<MimirApp> {
  final $theme = Settings.theme.listenThemeChange();
  final $routingConfig = ValueNotifier(buildRoutingConfig());
  final $focusMode = Settings.listenFocusTimetable();

  @override
  void initState() {
    super.initState();
    $theme.addListener(refresh);
    $focusMode.addListener(refreshFocusMode);
  }

  @override
  void dispose() {
    $theme.removeListener(refresh);
    $focusMode.removeListener(refreshFocusMode);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  void refreshFocusMode() {
    $routingConfig.value = Settings.focusTimetable ? buildFocusModeRouter() : buildRoutingConfig();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Settings.theme.themeColor;

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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android:
                SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
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
      routerConfig: buildRouter($routingConfig),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: Settings.theme.themeMode,
      theme: bakeTheme(ThemeData.light(
        useMaterial3: true,
      )),
      darkTheme: bakeTheme(ThemeData.dark(
        useMaterial3: true,
      )),
      builder: (ctx, child) => OaAuthManager(
        child: OaOnlineManager(
          child: child ?? const SizedBox(),
        ),
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
