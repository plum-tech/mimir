import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/index.dart';
import 'package:sit/me/edu_email/page/login.dart';
import 'package:sit/me/edu_email/page/outbox.dart';
import 'package:sit/school/ywb/page/meta.dart';
import 'package:sit/school/ywb/page/application.dart';
import 'package:sit/settings/page/life.dart';
import 'package:sit/settings/page/proxy.dart';
import 'package:sit/settings/page/school.dart';
import 'package:sit/settings/page/storage.dart';
import 'package:sit/life/expense_records/page/records.dart';
import 'package:sit/life/expense_records/page/statistics.dart';
import 'package:sit/life/index.dart';
import 'package:sit/login/page/index.dart';
import 'package:sit/me/edu_email/page/inbox.dart';
import 'package:sit/me/network_tool/page/index.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/page/palette.dart';
import 'package:sit/widgets/not_found.dart';
import 'package:sit/school/oa_announce/entity/announce.dart';
import 'package:sit/school/oa_announce/page/details.dart';
import 'package:sit/school/exam_arrange/page/index.dart';
import 'package:sit/school/library/index.dart';
import 'package:sit/school/oa_announce/page/list.dart';
import 'package:sit/scanner/page/index.dart';
import 'package:sit/school/class2nd/entity/list.dart';
import 'package:sit/school/class2nd/page/details.dart';
import 'package:sit/school/class2nd/page/list.dart';
import 'package:sit/school/class2nd/page/attended.dart';
import 'package:sit/school/exam_result/page/evaluation.dart';
import 'package:sit/school/exam_result/page/result.dart';
import 'package:sit/school/yellow_pages/page/index.dart';
import 'package:sit/settings/page/credentials.dart';
import 'package:sit/settings/page/developer.dart';
import 'package:sit/settings/page/index.dart';
import 'package:sit/me/index.dart';
import 'package:sit/school/index.dart';
import 'package:sit/settings/page/timetable.dart';
import 'package:sit/timetable/entity/timetable.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/page/import.dart';
import 'package:sit/timetable/page/index.dart';
import 'package:sit/timetable/page/mine.dart';
import 'package:sit/timetable/page/p13n.dart';
import 'package:sit/timetable/page/preview.dart';
import 'package:sit/widgets/image.dart';
import 'package:sit/widgets/webview/page.dart';

final $Key = GlobalKey<NavigatorState>();
final $TimetableShellKey = GlobalKey<NavigatorState>();
final $LifeShellKey = GlobalKey<NavigatorState>();
final $SchoolShellKey = GlobalKey<NavigatorState>();
final $MeShellKey = GlobalKey<NavigatorState>();

bool isLoginGuarded(BuildContext ctx) {
  final auth = ctx.auth;
  return auth.loginStatus != LoginStatus.validated && auth.credentials == null;
}

String? _loginRequired(BuildContext ctx, GoRouterState state) {
  if (isLoginGuarded(ctx)) return "/login?guard=true";
  return null;
}

FutureOr<String?> _redirectRoot(BuildContext ctx, GoRouterState state) {
  final auth = ctx.auth;
  if (auth.loginStatus == LoginStatus.never) {
// allow to access settings page.
    if (state.matchedLocation.startsWith("/tools")) return null;
    if (state.matchedLocation.startsWith("/settings")) return null;
// allow to access browser page.
    if (state.matchedLocation == "/browser") return null;
    return "/login";
  }
  return null;
}

Widget _onError(BuildContext context, GoRouterState state) {
  return NotFoundPage(state.uri.toString());
}

final _timetableRoute = GoRoute(
  path: "/timetable",
// Timetable is the home page.
  builder: (ctx, state) => const TimetablePage(),
  routes: [
    GoRoute(
      path: "preview/:id",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is SitTimetable) return TimetablePreviewPage(timetable: extra);
        final id = int.tryParse(state.pathParameters["id"] ?? "");
        if (id == null) throw 404;
        final timetable = TimetableInit.storage.timetable[id];
        if (timetable == null) throw 404;
        return TimetablePreviewPage(timetable: timetable);
      },
    ),
    GoRoute(
      path: "import",
      builder: (ctx, state) => const ImportTimetablePage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "mine",
      builder: (ctx, state) => const MyTimetableListPage(),
    ),
    GoRoute(
      path: "p13n",
      builder: (ctx, state) {
        final query = state.uri.query;
        return switch (query) {
          "custom" => const TimetableP13nPage(tab: TimetableP13nTab.custom),
          "builtin" => const TimetableP13nPage(tab: TimetableP13nTab.builtin),
          _ => const TimetableP13nPage(),
        };
      },
      routes: [
        GoRoute(
            path: "palette/:id",
            builder: (ctx, state) {
              final extra = state.extra;
              final id = int.tryParse(state.pathParameters["id"] ?? "");
              if (id == null) throw 404;
              if (extra is TimetablePalette) return TimetablePaletteEditor(id: id, palette: extra);
              final palette = TimetableInit.storage.palette[id];
              if (palette == null) throw 404;
              return TimetablePaletteEditor(id: id, palette: palette);
            }),
      ],
    ),
  ],
);

final _schoolRoute = GoRoute(
  path: "/school",
  builder: (ctx, state) => const SchoolPage(),
);
final _lifeRoute = GoRoute(
  path: "/life",
  builder: (ctx, state) => const LifePage(),
);
final _meRoute = GoRoute(
  path: "/me",
  builder: (ctx, state) => const MePage(),
);
final _toolRoutes = [
  GoRoute(
    path: "/tools/network-tool",
    builder: (ctx, state) => const NetworkToolPage(),
  ),
  GoRoute(
    path: "/tools/scanner",
    parentNavigatorKey: $Key,
    builder: (ctx, state) => const ScannerPage(),
  ),
];
final _settingsRoute = GoRoute(
  path: "/settings",
  builder: (ctx, state) => const SettingsPage(),
  routes: [
    GoRoute(
      path: "credentials",
      builder: (ctx, state) => const CredentialsPage(),
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
      path: "activity-detail",
      builder: (ctx, state) {
        final enableApply = state.uri.queryParameters["enable-apply"] != null;
        final extra = state.extra;
        if (extra is Class2ndActivity) {
          return Class2ndActivityDetailsPage(extra, enableApply: enableApply);
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
final _eduEmailRoutes = [
  GoRoute(
    path: "/yellow-pages",
    builder: (ctx, state) => const YellowPagesListPage(),
  ),
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
  builder: (ctx, state) => const YwbApplicationMetaListPage(),
  redirect: _loginRequired,
  routes: [
    GoRoute(
      path: "mine",
      builder: (ctx, state) => const YwbMyApplicationListPage(),
    ),
  ],
);

final _imageRoute = GoRoute(
  path: "/image",
  builder: (ctx, state) {
    final extra = state.extra;
    if (extra is String?) {
      return ImageViewPage(
        extra,
        title: state.uri.queryParameters["title"],
      );
    }
    throw 400;
  },
);

final _loginRoute = GoRoute(
  path: "/login",
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

final _libraryRoute = GoRoute(
  path: "/library",
  builder: (ctx, state) => const LibraryPage(),
);

final _examArrange = GoRoute(
  path: "/exam-arrange",
  builder: (ctx, state) => const ExamArrangePage(),
  redirect: _loginRequired,
);

final _examResult = GoRoute(
  path: "/exam-result",
  builder: (ctx, state) => const ExamResultPage(),
  redirect: _loginRequired,
);

final _browserRoute = GoRoute(
  path: "/browser",
  builder: (ctx, state) {
    final extra = state.extra;
    if (extra is String) {
      return WebViewPage(initialUrl: extra);
    }
    throw 404;
  },
);

GoRouter buildRouter(ValueNotifier<RoutingConfig> $routingConfig) {
  return GoRouter.routingConfig(
    routingConfig: $routingConfig,
    navigatorKey: $Key,
    initialLocation: "/",
    debugLogDiagnostics: kDebugMode,
    errorBuilder: _onError,
  );
}

RoutingConfig buildCommonRoutingConfig() {
  return RoutingConfig(
    redirect: _redirectRoot,
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => "/timetable",
      ),
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, navigationShell) {
          return MainStagePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: $TimetableShellKey,
            routes: [
              _timetableRoute,
            ],
          ),
          StatefulShellBranch(
            navigatorKey: $SchoolShellKey,
            routes: [
              _schoolRoute,
            ],
          ),
          StatefulShellBranch(
            navigatorKey: $LifeShellKey,
            routes: [
              _lifeRoute,
            ],
          ),
          StatefulShellBranch(
            navigatorKey: $MeShellKey,
            routes: [
              _meRoute,
            ],
          ),
        ],
      ),
      _browserRoute,
      _expenseRoute,
      _settingsRoute,
      ..._toolRoutes,
      _class2ndRoute,
      _oaAnnounceRoute,
      ..._eduEmailRoutes,
      _ywbRoute,
      _examResult,
      _examArrange,
      _libraryRoute,
      _teacherEvalRoute,
      _loginRoute,
      _imageRoute,
    ],
  );
}

RoutingConfig buildTimetableFocusRouter() {
  return RoutingConfig(
    redirect: _redirectRoot,
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => "/timetable",
      ),
      _timetableRoute,
      _meRoute,
      _schoolRoute,
      _lifeRoute,
      _browserRoute,
      _expenseRoute,
      _settingsRoute,
      ..._toolRoutes,
      _class2ndRoute,
      _oaAnnounceRoute,
      ..._eduEmailRoutes,
      _ywbRoute,
      _examResult,
      _examArrange,
      _libraryRoute,
      _teacherEvalRoute,
      _loginRoute,
      _imageRoute,
    ],
  );
}
