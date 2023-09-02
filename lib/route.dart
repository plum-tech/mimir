import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/main/index.dart';

import 'app.dart';
import 'mini_apps/exam_result/page/evaluation.dart';
import 'mini_apps/symbol.dart';

String? _loginRequired(BuildContext ctx, GoRouterState state) {
  final auth = ctx.auth;
  if (auth.loginStatus != LoginStatus.validated && auth.oaCredential == null) {
    return "/relogin";
  }
  return null;
}

final router = GoRouter(
  navigatorKey: $Key,
  initialLocation: "/",
  redirect: (ctx, state) {
    final auth = ctx.auth;
    if (auth.loginStatus == LoginStatus.never) {
      return "/login";
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: "/",
      builder: (ctx, state) => MainStagePage(),
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
      builder: (ctx, state) => const MailPage(),
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
    ),
    GoRoute(
      path: "/app/library",
      builder: (ctx, state) => const LibraryPage(),
    ),
    GoRoute(
      path: "/app/timetable",
      builder: (ctx, state) => const TimetableIndexPage(),
    ),
    GoRoute(
      path: "/app/timetable/import",
      builder: (ctx, state) => const ImportTimetableIndexPage(),
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
      builder: (ctx, state) => const LoginPage(disableOffline: false),
    ),
    GoRoute(
      path: "/relogin",
      builder: (ctx, state) => const UnauthorizedTipPage(),
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
