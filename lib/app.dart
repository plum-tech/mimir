import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/mini_apps/activity/using.dart';
import 'package:mimir/route.dart';

final $Key = GlobalKey<NavigatorState>();

class MimirApp extends StatefulWidget {
  const MimirApp({super.key});

  @override
  State<MimirApp> createState() => _MimirAppState();
}

class _MimirAppState extends State<MimirApp> {

  @override
  Widget build(BuildContext context) {
    final primaryColor = Settings.themeColor ?? R.defaultThemeColor;
    return ScreenUtilInit(
      builder: (BuildContext content, Widget? widget) {
        return KeyboardListener(
          onKeyEvent: (event) {
            Log.info('按键事件: ${event.logicalKey}');
            if (event is KeyUpEvent && LogicalKeyboardKey.escape == event.logicalKey) {
              Log.info('松开返回键');
              final ctx = $Key.currentContext;
              if (ctx != null && Navigator.canPop(ctx)) {
                Navigator.pop(ctx);
              }
            }
          },
          focusNode: FocusNode(),
          child: MaterialApp.router(
            title: R.appName,
            routerConfig: router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: Settings.themeMode ?? ThemeMode.system,
            theme: ThemeData(
              primaryColor: primaryColor,
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android:
                      SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
                  TargetPlatform.iOS:
                      SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
                  TargetPlatform.macOS:
                      SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
                  TargetPlatform.linux:
                      SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
                  TargetPlatform.windows:
                      SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
                },
              ),
              visualDensity: VisualDensity.comfortable,
              appBarTheme: const AppBarTheme(
                toolbarHeight: 40,
              ),
            ),
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(builder: (context, widget) {
              return MediaQuery(
                // 设置文字大小不随系统设置改变
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: AdaptiveUI(
                  isSubpage: false,
                  child: OaAuthManager(
                    child: widget!,
                  ),
                ),
              );
            }),
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.unknown
              },
            ),
          ),
        );
      },
    );
  }
}
