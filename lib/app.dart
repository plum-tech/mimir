import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/credential/widgets/scope.dart';
import 'package:mimir/mini_apps/activity/using.dart';
import 'package:mimir/route.dart';
import 'package:rettulf/rettulf.dart';

final $Key = GlobalKey<NavigatorState>();

class MimirApp extends StatefulWidget {
  const MimirApp({super.key});

  @override
  State<MimirApp> createState() => _MimirAppState();
}

class _MimirAppState extends State<MimirApp> {
  @override
  void initState() {
    super.initState();
    // Initialize the app with system theme.
    var platformBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    Kv.theme.isDarkMode ??= platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Dark mode.
    final isDark = true || (Kv.theme.isDarkMode ?? false);
    final primaryColor = Kv.theme.color ?? R.defaultThemeColor;

    buildMaterialWithTheme(ThemeData theme) {
      if (kDebugMode) {
        debugPaintSizeEnabled = false;
      }
      return MaterialApp.router(
        title: R.appName,
        routerConfig: router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: theme.copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android:
                  SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
              TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
              TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
              TargetPlatform.linux: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
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
          if (context.isPortrait) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
          }
          return MediaQuery(
            // 设置文字大小不随系统设置改变
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AdaptiveUI(
              isSubpage: false,
              child: AuthManager(
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
      );
    }

    buildWidgetWithKeyboardListener(Widget child) {
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
        child: child,
      );
    }

    return ScreenUtilInit(
      builder: (BuildContext content, Widget? widget) => DynamicColorTheme(
        defaultColor: primaryColor,
        defaultIsDark: isDark,
        data: (Color color, bool isDark) {
          return ThemeData(
            colorSchemeSeed: primaryColor,
            brightness: isDark ? Brightness.dark : Brightness.light,
            useMaterial3: true,
          );
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return buildWidgetWithKeyboardListener(buildMaterialWithTheme(theme));
        },
      ),
    );
  }
}
