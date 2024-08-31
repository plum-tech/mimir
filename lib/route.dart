import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/forum/page/index.dart';
import 'package:mimir/backend/user/page/sign_in.dart';
import 'package:mimir/credentials/entity/login_status.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/game/2048/page/index.dart';
import 'package:mimir/game/2048/page/records.dart';
import 'package:mimir/game/index.dart';
import 'package:mimir/game/minesweeper/page/index.dart';
import 'package:mimir/game/page/settings.dart';
import 'package:mimir/game/sudoku/page/index.dart';
import 'package:mimir/game/sudoku/page/records.dart';
import 'package:mimir/game/suika/index.dart';
import 'package:mimir/game/wordle/page/index.dart';
import 'package:mimir/index.dart';
import 'package:mimir/life/page/settings.dart';
import 'package:mimir/lifecycle.dart';
import 'package:mimir/me/edu_email/page/login.dart';
import 'package:mimir/me/edu_email/page/outbox.dart';
import 'package:mimir/school/class2nd/entity/attended.dart';
import 'package:mimir/school/exam_result/page/gpa.dart';
import 'package:mimir/school/exam_result/page/result.pg.dart';
import 'package:mimir/school/library/page/history.dart';
import 'package:mimir/school/library/page/login.dart';
import 'package:mimir/school/library/page/borrowing.dart';
import 'package:mimir/school/student_plan/course_selection/page/index.dart';
import 'package:mimir/school/ywb/entity/service.dart';
import 'package:mimir/school/ywb/page/details.dart';
import 'package:mimir/school/ywb/page/service.dart';
import 'package:mimir/school/ywb/page/application.dart';
import 'package:mimir/settings/page/about.dart';
import 'package:mimir/settings/page/language.dart';
import 'package:mimir/settings/page/mimir.dart';
import 'package:mimir/settings/page/oa.dart';
import 'package:mimir/settings/page/proxy.dart';
import 'package:mimir/school/page/settings.dart';
import 'package:mimir/settings/page/storage.dart';
import 'package:mimir/life/expense_records/page/records.dart';
import 'package:mimir/life/expense_records/page/statistics.dart';
import 'package:mimir/life/index.dart';
import 'package:mimir/login/page/index.dart';
import 'package:mimir/me/edu_email/page/inbox.dart';
import 'package:mimir/network/page/index.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/settings/page/theme_color.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/p13n/entity/palette.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/p13n/page/background.dart';
import 'package:mimir/timetable/p13n/page/cell_style.dart';
import 'package:mimir/timetable/page/edit/editor.dart';
import 'package:mimir/timetable/p13n/page/palette_editor.dart';
import 'package:mimir/timetable/patch/page/patch.dart';
import 'package:mimir/timetable/page/settings.dart';
import 'package:mimir/widgets/inapp_webview/page.dart';
import 'package:mimir/widgets/not_found.dart';
import 'package:mimir/school/oa_announce/entity/announce.dart';
import 'package:mimir/school/oa_announce/page/details.dart';
import 'package:mimir/school/exam_arrange/page/list.dart';
import 'package:mimir/school/oa_announce/page/list.dart';
import 'package:mimir/intent/qrcode/page/scanner.dart';
import 'package:mimir/school/class2nd/page/details.dart';
import 'package:mimir/school/class2nd/page/activity.dart';
import 'package:mimir/school/class2nd/page/attended.dart';
import 'package:mimir/school/exam_result/page/evaluation.dart';
import 'package:mimir/school/exam_result/page/result.ug.dart';
import 'package:mimir/school/yellow_pages/page/index.dart';
import 'package:mimir/settings/page/developer.dart';
import 'package:mimir/settings/page/index.dart';
import 'package:mimir/me/index.dart';
import 'package:mimir/school/index.dart';
import 'package:mimir/timetable/page/import.dart';
import 'package:mimir/timetable/page/index.dart';
import 'package:mimir/timetable/page/mine.dart';
import 'package:mimir/timetable/p13n/page/palette.dart';
import 'package:mimir/widgets/image.dart';

import 'game/minesweeper/page/records.dart';

final $TimetableShellKey = GlobalKey<NavigatorState>();
final $SchoolShellKey = GlobalKey<NavigatorState>();
final $LifeShellKey = GlobalKey<NavigatorState>();
final $GameShellKey = GlobalKey<NavigatorState>();
final $MeShellKey = GlobalKey<NavigatorState>();
final $ForumShellKey = GlobalKey<NavigatorState>();

bool isLoginGuarded(BuildContext ctx) {
  if (Dev.demoMode) return false;
  final loginStatus = ProviderScope.containerOf(ctx).read(CredentialsInit.storage.oa.$loginStatus);
  final credentials = ProviderScope.containerOf(ctx).read(CredentialsInit.storage.oa.$credentials);
  return loginStatus != LoginStatus.validated && credentials == null;
}

String? _loginRequired(BuildContext ctx, GoRouterState state) {
  if (isLoginGuarded(ctx)) return "/oa/login?guard=true";
  return null;
}

FutureOr<String?> _redirectRoot(BuildContext ctx, GoRouterState state) {
  // `ctx.riverpod().read(CredentialsInit.storage.oa.$loginStatus)` would return `LoginStatus.never` after just logged in.
  final loginStatus = CredentialsInit.storage.oa.loginStatus;
  if (loginStatus == LoginStatus.never) {
// allow to access settings page.
    if (state.matchedLocation.startsWith("/tools")) return null;
    if (state.matchedLocation.startsWith("/settings")) return null;
// allow to access browser page.
    if (state.matchedLocation == "/browser") return null;
    return "/oa/login";
  }
  return null;
}

Widget _onError(BuildContext context, GoRouterState state) {
  return NotFoundPage(state.uri.toString());
}

final _timetableShellRoute = GoRoute(
  path: "/timetable",
// Timetable is the home page.
  builder: (ctx, state) => const TimetablePage(),
);

SitTimetable? _getTimetable(GoRouterState state) {
  final extra = state.extra;
  if (extra is SitTimetable) return extra;
  final id = int.tryParse(state.pathParameters["id"] ?? "");
  if (id == null) return null;
  final timetable = TimetableInit.storage.timetable[id];
  return timetable;
}

TimetablePalette? _getTimetablePalette(GoRouterState state) {
  final extra = state.extra;
  if (extra is TimetablePalette) return extra;
  final id = int.tryParse(state.pathParameters["id"] ?? "");
  if (id == null) return null;
  final palette = TimetableInit.storage.palette[id];
  return palette;
}

final _timetableRoutes = [
  GoRoute(
    path: "/timetable/import",
    builder: (ctx, state) => const ImportTimetablePage(),
    redirect: _loginRequired,
  ),
  GoRoute(
    path: "/timetable/mine",
    builder: (ctx, state) => const MyTimetableListPage(),
  ),
  GoRoute(
    path: "/timetable/p13n",
    builder: (ctx, state) => const TimetableP13nPage(),
    routes: [
      GoRoute(
        path: "custom",
        builder: (ctx, state) => const TimetableP13nPage(tab: TimetableP13nTab.custom),
      ),
      GoRoute(
        path: "builtin",
        builder: (ctx, state) => const TimetableP13nPage(tab: TimetableP13nTab.builtin),
      ),
    ],
  ),
  GoRoute(
    path: "/timetable/palette/edit/:id",
    builder: (ctx, state) {
      final palette = _getTimetablePalette(state);
      if (palette == null) throw 404;
      return TimetablePaletteEditorPage(palette: palette);
    },
  ),
  GoRoute(
    path: "/timetable/edit/:id",
    builder: (ctx, state) {
      final timetable = _getTimetable(state);
      if (timetable == null) throw 404;
      return TimetableEditorPage(timetable: timetable);
    },
  ),
  GoRoute(
    path: "/timetable/patch/edit/:id",
    builder: (ctx, state) {
      final timetable = _getTimetable(state);
      if (timetable == null) throw 404;
      return TimetablePatchEditorPage(timetable: timetable);
    },
  ),
  GoRoute(
    path: "/timetable/cell-style",
    builder: (ctx, state) => const TimetableCellStyleEditor(),
  ),
  GoRoute(
    path: "/timetable/background",
    builder: (ctx, state) => const TimetableBackgroundEditor(),
  ),
];

final _schoolShellRoute = GoRoute(
  path: "/school",
  builder: (ctx, state) => const SchoolPage(),
);
final _lifeShellRoute = GoRoute(
  path: "/life",
  builder: (ctx, state) => const LifePage(),
);
final _gameShellRoute = GoRoute(
  path: "/game",
  builder: (ctx, state) => const GamePage(),
);
final _meShellRoute = GoRoute(
  path: "/me",
  builder: (ctx, state) => const MePage(),
);
final _mimirRoutes = [
  GoRoute(
    path: "/mimir/sign-in",
    builder: (ctx, state) => const MimirSignInPage(),
  ),
  GoRoute(
    path: "/mimir/forum",
    builder: (ctx, state) => const MimirForumPage(),
  ),
];
final _toolsRoutes = [
  GoRoute(
    path: "/tools/network-tool",
    builder: (ctx, state) => const NetworkToolPage(),
  ),
  GoRoute(
    path: "/tools/scanner",
    parentNavigatorKey: $key,
    builder: (ctx, state) => const ScannerPage(),
  ),
];
final _settingsRoute = GoRoute(
  path: "/settings",
  builder: (ctx, state) => const SettingsPage(),
  routes: [
    GoRoute(
      path: "mimir",
      builder: (ctx, state) => const MimirSettingsPage(),
    ),
    GoRoute(
      path: "language",
      builder: (ctx, state) => const LanguagePage(),
    ),
    GoRoute(
      path: "theme-color",
      builder: (ctx, state) => const ThemeColorPage(),
    ),
    GoRoute(
      path: "oa",
      builder: (ctx, state) => const OaSettingsPage(),
    ),
    GoRoute(
      path: "timetable",
      builder: (ctx, state) => const TimetableSettingsPage(),
    ),
    GoRoute(
      path: "school",
      builder: (ctx, state) => const SchoolSettingsPage(),
    ),
    GoRoute(
      path: "life",
      builder: (ctx, state) => const LifeSettingsPage(),
    ),
    GoRoute(
      path: "game",
      builder: (ctx, state) => const GameSettingsPage(),
    ),
    GoRoute(
      path: "about",
      builder: (ctx, state) => const AboutSettingsPage(),
    ),
    GoRoute(
      path: "proxy",
      builder: (ctx, state) => const ProxySettingsPage(),
    ),
    GoRoute(
      path: "developer",
      builder: (ctx, state) => const DeveloperOptionsPage(),
      routes: [
        GoRoute(
          path: "local-storage",
          builder: (ctx, state) => const LocalStoragePage(),
        )
      ],
    ),
  ],
);
final _expenseRoute = GoRoute(
  path: "/expense-records",
  builder: (ctx, state) => const ExpenseRecordsPage(),
  redirect: _loginRequired,
  routes: [
    GoRoute(
      path: "statistics",
      builder: (ctx, state) => const ExpenseStatisticsPage(),
      redirect: _loginRequired,
    )
  ],
);

final _class2ndRoute = GoRoute(
  path: "/class2nd",
  builder: (ctx, state) => const ActivityListPage(),
  redirect: _loginRequired,
  routes: [
    GoRoute(
      path: "attended",
      builder: (ctx, state) => const AttendedActivityPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "activity-details/:id",
      builder: (ctx, state) {
        final id = int.tryParse(state.pathParameters["id"] ?? "");
        if (id == null) throw 404;
        final enableApply = state.uri.queryParameters["enable-apply"] != null;
        final title = state.uri.queryParameters["title"];
        final time = DateTime.tryParse(state.uri.queryParameters["time"] ?? "");
        return Class2ndActivityDetailsPage(activityId: id, title: title, time: time, enableApply: enableApply);
      },
      redirect: _loginRequired,
    ),
    // TODO: using path para
    GoRoute(
      path: "attended-details",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is Class2ndAttendedActivity) {
          return Class2ndApplicationDetailsPage(extra);
        }
        throw 404;
      },
      redirect: _loginRequired,
    ),
  ],
);

final _oaAnnounceRoute = GoRoute(
  path: "/oa-announce",
  builder: (ctx, state) => const OaAnnounceListPage(),
  redirect: _loginRequired,
  routes: [
    // TODO: using path para
    GoRoute(
      path: "details",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is OaAnnounceRecord) {
          return AnnounceDetailsPage(extra);
        }
        throw 404;
      },
    ),
  ],
);
final _yellowPagesRoute = GoRoute(
  path: "/yellow-pages",
  builder: (ctx, state) => const YellowPagesListPage(),
);
final _eduEmailRoutes = [
  GoRoute(
    path: "/edu-email/login",
    builder: (ctx, state) => const EduEmailLoginPage(),
  ),
  GoRoute(
    path: "/edu-email/inbox",
    builder: (ctx, state) => const EduEmailInboxPage(),
  ),
  GoRoute(
    path: "/edu-email/outbox",
    builder: (ctx, state) => const EduEmailOutboxPage(),
  ),
];

final _ywbRoute = GoRoute(
  path: "/ywb",
  builder: (ctx, state) => const YwbServiceListPage(),
  redirect: _loginRequired,
  routes: [
    GoRoute(
      path: "mine",
      builder: (ctx, state) => const YwbMyApplicationListPage(),
    ),
    // TODO: using path para
    GoRoute(
      path: "details",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is YwbService) {
          return YwbServiceDetailsPage(meta: extra);
        }
        throw 404;
      },
    ),
  ],
);

final _imageRoute = GoRoute(
  path: "/image",
  builder: (ctx, state) {
    final extra = state.extra;
    final data = state.uri.queryParameters["origin"] ?? extra as String?;
    if (data != null) {
      return ImageViewPage(
        data,
        title: state.uri.queryParameters["title"],
      );
    }
    throw 400;
  },
);

final _oaLoginRoute = GoRoute(
  path: "/oa/login",
  builder: (ctx, state) {
    final guarded = state.uri.queryParameters["guard"] == "true";
    return LoginPage(isGuarded: guarded);
  },
);

final _teacherEvalRoute = GoRoute(
  path: "/teacher-eval",
  builder: (ctx, state) => const TeacherEvaluationPage(),
  redirect: _loginRequired,
);

final _libraryRoutes = [
  GoRoute(
    path: "/library/login",
    builder: (ctx, state) => const LibraryLoginPage(),
  ),
  GoRoute(
    path: "/library/borrowing",
    builder: (ctx, state) => const LibraryBorrowingPage(),
  ),
  GoRoute(
    path: "/library/borrowing-history",
    builder: (ctx, state) => const LibraryMyBorrowingHistoryPage(),
  ),
];

final _examArrange = GoRoute(
  path: "/exam-arrange",
  builder: (ctx, state) => const ExamArrangementListPage(),
  redirect: _loginRequired,
);

final _examResultRoute = GoRoute(
  path: "/exam-result",
  routes: [
    GoRoute(path: "ug", builder: (ctx, state) => const ExamResultUgPage(), routes: [
      GoRoute(
        path: "gpa",
        builder: (ctx, state) => const GpaCalculatorPage(),
      ),
    ]),
    GoRoute(
      path: "pg",
      builder: (ctx, state) => const ExamResultPgPage(),
    ),
  ],
  redirect: _loginRequired,
);

final _browserRoute = GoRoute(
  path: "/browser",
  builder: (ctx, state) {
    var url = state.uri.queryParameters["url"] ?? state.extra;
    if (url is String) {
      if (!url.startsWith("http://") && !url.startsWith("https://")) {
        url = "http://$url";
      }
      // return WebViewPage(initialUrl: url);
      return InAppWebViewPage(initialUri: WebUri(url));
    }
    throw 400;
  },
);
final _gameRoutes = [
  GoRoute(
    path: "/game/2048",
    builder: (ctx, state) {
      final continueGame = state.uri.queryParameters["continue"] != null;
      return Game2048Page(newGame: !continueGame);
    },
    routes: [
      GoRoute(
        path: "records",
        builder: (ctx, state) {
          return const Records2048Page();
        },
      ),
    ],
  ),
  GoRoute(
    path: "/game/minesweeper",
    builder: (ctx, state) {
      final continueGame = state.uri.queryParameters["continue"] != null;
      return GameMinesweeperPage(newGame: !continueGame);
    },
    routes: [
      GoRoute(
        path: "records",
        builder: (ctx, state) {
          return const RecordsMinesweeperPage();
        },
      ),
    ],
  ),
  GoRoute(
    path: "/game/sudoku",
    builder: (ctx, state) {
      final continueGame = state.uri.queryParameters["continue"] != null;
      return GameSudokuPage(newGame: !continueGame);
    },
    routes: [
      GoRoute(
        path: "records",
        builder: (ctx, state) {
          return const RecordsSudokuPage();
        },
      ),
    ],
  ),
  GoRoute(
    path: "/game/suika",
    builder: (ctx, state) => const GameSuikaPage(),
  ),
  GoRoute(
    path: "/game/wordle",
    builder: (ctx, state) => const GameWordlePage(),
  ),
];

final _courseSelectionRoute = GoRoute(
  path: "/select-course",
  builder: (ctx, state) => const CourseSelectionPage(),
);

GoRouter buildRouter(ValueNotifier<RoutingConfig> $routingConfig) {
  return GoRouter.routingConfig(
    routingConfig: $routingConfig,
    navigatorKey: $key,
    initialLocation: "/",
    debugLogDiagnostics: kDebugMode,
    // onException: _onException,
    errorBuilder: _onError,
  );
}

String _getRootRoute() {
  final available = [
    "/timetable",
    "/life",
    "/school",
    "/game",
    "/me",
  ];
  if (!Settings.timetable.showTimetableNavigation) {
    available.remove("/timetable");
  }
  if (kIsWeb) {
    available.remove("/school");
    available.remove("/life");
  }
  return available.first;
}

RoutingConfig buildCommonRoutingConfig() {
  return RoutingConfig(
    redirect: _redirectRoot,
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => _getRootRoute(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, navigationShell) {
          return MainStagePage(navigationShell: navigationShell);
        },
        branches: [
          if (!kIsWeb)
            StatefulShellBranch(
              navigatorKey: $SchoolShellKey,
              routes: [
                _schoolShellRoute,
              ],
            ),
          if (!kIsWeb)
            StatefulShellBranch(
              navigatorKey: $LifeShellKey,
              routes: [
                _lifeShellRoute,
              ],
            ),
          StatefulShellBranch(
            navigatorKey: $TimetableShellKey,
            routes: [
              _timetableShellRoute,
            ],
          ),
          StatefulShellBranch(
            navigatorKey: $GameShellKey,
            routes: [
              _gameShellRoute,
            ],
          ),
          // StatefulShellBranch(
          //   navigatorKey: $ForumShellKey,
          //   routes: [
          //     _forumShellRoute,
          //   ],
          // ),
          StatefulShellBranch(
            navigatorKey: $MeShellKey,
            routes: [
              _meShellRoute,
            ],
          ),
        ],
      ),
      ..._mimirRoutes,
      ..._timetableRoutes,
      _browserRoute,
      _expenseRoute,
      _settingsRoute,
      _yellowPagesRoute,
      ..._toolsRoutes,
      _class2ndRoute,
      _oaAnnounceRoute,
      ..._eduEmailRoutes,
      _ywbRoute,
      _examResultRoute,
      _examArrange,
      ..._libraryRoutes,
      _teacherEvalRoute,
      _oaLoginRoute,
      _imageRoute,
      ..._gameRoutes,
      _courseSelectionRoute,
    ],
  );
}

RoutingConfig buildTimetableFocusRouter() {
  return RoutingConfig(
    redirect: _redirectRoot,
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => _getRootRoute(),
      ),
      ..._mimirRoutes,
      _timetableShellRoute,
      ..._timetableRoutes,
      _schoolShellRoute,
      _gameShellRoute,
      _lifeShellRoute,
      _meShellRoute,
      _browserRoute,
      _expenseRoute,
      _settingsRoute,
      _yellowPagesRoute,
      ..._toolsRoutes,
      _class2ndRoute,
      _oaAnnounceRoute,
      ..._eduEmailRoutes,
      _ywbRoute,
      _examResultRoute,
      _examArrange,
      ..._libraryRoutes,
      _teacherEvalRoute,
      _oaLoginRoute,
      _imageRoute,
      ..._gameRoutes,
      _courseSelectionRoute,
    ],
  );
}
