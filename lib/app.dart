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

import 'navigation/route.dart';

final $Key = GlobalKey<NavigatorState>();

class MimirApp extends StatefulWidget {
  const MimirApp({super.key});

  @override
  State<MimirApp> createState() => _MimirAppState();
}

class _MimirAppState extends State<MimirApp> {
  // 先使用默认的路由表
  IRouteGenerator routeGenerator = defaultRouteTable;

  @override
  void initState() {
    super.initState();
    // Initialize the app with system theme.
    var platformBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    Kv.theme.isDarkMode ??= platformBrightness == Brightness.dark;
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return routeGenerator.generateRoute(settings.name ?? "", args,context);
      },
      settings: settings,
    );
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
      return MaterialApp(
        title: R.appName,
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
        initialRoute: Routes.root,
        debugShowCheckedModeBanner: false,
        navigatorKey: $Key,
        onGenerateRoute: _onGenerateRoute,
        builder: EasyLoading.init(builder: (context, widget) {
          // A workaround to get the system locale.
          final systemLocale = Localizations.localeOf(context);
          Lang.setCurrentLocaleIfAbsent(systemLocale);
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
              child: AuthScopeMaker(
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
