import 'dart:convert';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:catcher/core/catcher.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/credential/user_widget/scope.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:mimir/route.dart';
import 'package:rettulf/rettulf.dart';

import 'global/desktop_init.dart';
import 'global/global.dart';
import 'navigation/route.dart';

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
        return routeGenerator.onGenerateRoute(settings.name!, args)(context);
      },
      settings: settings,
    );
  }

  TextTheme _buildTextTheme(bool isDark, Color primaryColor) {
    final fullColor = isDark ? Colors.white : Colors.black;
    final halfColor = isDark ? Colors.white70 : Colors.black87;

    return TextTheme(
      // https://material.io/design/typography/the-type-system.html
      // https://www.mdui.org/design/style/typography.html
      // 12、14、16、20
      displayLarge: TextStyle(fontSize: 24.0, color: fullColor, fontWeight: FontWeight.w500),
      displayMedium: TextStyle(fontSize: 22.0, color: fullColor),
      displaySmall: TextStyle(fontSize: 20.0, color: halfColor, fontWeight: FontWeight.w500),
      headlineMedium: TextStyle(fontSize: 20.0, color: halfColor),
      headlineSmall: TextStyle(fontSize: 24.0, color: fullColor),
      titleLarge: TextStyle(fontSize: 20.0, color: fullColor, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 18.0, color: halfColor, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 16.0, color: halfColor, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16.0, color: fullColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: fullColor),
      bodySmall: TextStyle(fontSize: 12.0, color: halfColor),
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor, bool isDark) {
    return ThemeData(
        colorSchemeSeed: primaryColor,
        textTheme: _buildTextTheme(isDark, primaryColor),
        brightness: isDark ? Brightness.dark : Brightness.light,
        useMaterial3: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Kv.theme.isDarkMode ?? false;
    final primaryColor = Kv.theme.color ?? R.defaultThemeColor;

    buildMaterialWithTheme(ThemeData theme) {
      if (kDebugMode) {
        debugPaintSizeEnabled = false;
      }
      return MaterialApp(
        title: R.appName,
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
        initialRoute: RouteTable.root,
        debugShowCheckedModeBanner: false,
        navigatorKey: Catcher.navigatorKey,
        onGenerateRoute: _onGenerateRoute,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: Lang.supports,
        locale: Kv.pref.locale,
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
            final ctx = Catcher.navigatorKey?.currentContext;
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
          return _buildTheme(context, color, isDark);
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return buildWidgetWithKeyboardListener(buildMaterialWithTheme(theme));
        },
      ),
    );
  }
}
