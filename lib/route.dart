import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/main/index.dart';
import 'package:mimir/main/network_tool/page/index.dart';
import 'package:mimir/main/settings/page/index.dart';
import 'package:mimir/timetable/entity/entity.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/page/import.dart';
import 'package:mimir/timetable/page/index.dart';
import 'package:mimir/timetable/page/mine.dart';
import 'package:mimir/timetable/page/preview.dart';

import 'app.dart';
import 'login/page/index.dart';
import 'mini_apps/exam_result/page/evaluation.dart';
import 'mini_apps/symbol.dart';

String? _loginRequired(BuildContext ctx, GoRouterState state) {
  final auth = ctx.auth;
  if (auth.loginStatus != LoginStatus.validated && auth.credential == null) {
    return "/login/guard";
  }
  return null;
}

final router = GoRouter(
  navigatorKey: $Key,
  initialLocation: "/timetable",
  debugLogDiagnostics: kDebugMode,
  routes: [
    ShellRoute(
      builder: (ctx, state, child) {
        return MainStagePage(outlet: child);
      },
      routes: [
        GoRoute(
          path: "/timetable",
          builder: (ctx, state) => const TimetablePage(),
        ),
        GoRoute(
          path: "/settings",
          builder: (ctx, state) => const SettingsPage(),
        ),
        GoRoute(
          path: "/networkTool",
          builder: (ctx, state) => const NetworkToolPage(),
        ),
      ],
    ),
    GoRoute(
      path: "/app/activity",
      builder: (ctx, state) => const ActivityIndexPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/app/expense",
      builder: (ctx, state) => const ExpenseTrackerPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/app/oaAnnouncement",
      builder: (ctx, state) => const OaAnnouncePage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/app/yellowPages",
      builder: (ctx, state) => const YellowPagesPage(),
    ),
    GoRoute(
      path: "/app/eduEmail",
      builder: (ctx, state) => const EduEmailPage(),
    ),
    GoRoute(
      path: "/app/elecBill",
      builder: (ctx, state) => const ElectricityBillPage(),
    ),
    GoRoute(
      path: "/app/examResult",
      builder: (ctx, state) => const ExamResultPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/app/examArr",
      builder: (ctx, state) => const ExamArrangementPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/app/library",
      builder: (ctx, state) => const LibraryPage(),
    ),
    GoRoute(
      path: "/app/timetable",
      builder: (ctx, state) => const TimetablePage(),
    ),
    GoRoute(
      path: "/app/timetable/preview/:id",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is SitTimetable) {
          return TimetablePreviewPage(timetable: extra);
        }
        final id = state.pathParameters["id"];
        if (id == null) throw 400;
        final timetable = TimetableInit.storage.getSitTimetableById(id: id);
        if (timetable == null) throw 404;
        return TimetablePreviewPage(timetable: timetable);
      },
    ),
    GoRoute(
      path: "/app/timetable/import",
      builder: (ctx, state) => const ImportTimetablePage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/app/timetable/mine",
      builder: (ctx, state) => const MyTimetableListPage(),
    ),
    GoRoute(
      path: "/app/application",
      builder: (ctx, state) => const ApplicationIndexPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/scanner",
      builder: (ctx, state) => const ScannerPage(),
    ),
    GoRoute(
      path: "/teacherEval",
      builder: (ctx, state) => const EvaluationPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/login",
      builder: (ctx, state) => const LoginPage(isGuarded: false),
    ),
    GoRoute(
      path: "/login/guard",
      builder: (ctx, state) => const LoginPage(isGuarded: true),
    ),
  ],
);

/*
BrowserPage(
        initialUrl: args['initialUrl'],
        fixedTitle: args['fixedTitle'],
        showSharedButton: args['showSharedButton'],
        showRefreshButton: args['showRefreshButton'],
        showOpenInBrowser: args['showOpenInBrowser'],
        userAgent: args['userAgent'],
        javascript: args['javascript'],
        javascriptUrl: args['javascriptUrl'],
      );
 */
