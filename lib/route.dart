import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/life/expense_records/page/records.dart';
import 'package:mimir/life/expense_records/page/statistics.dart';
import 'package:mimir/life/index.dart';
import 'package:mimir/login/page/index.dart';
import 'package:mimir/main/index.dart';
import 'package:mimir/me/edu_email/page/index.dart';
import 'package:mimir/me/network_tool/page/index.dart';
import 'package:mimir/school/oa_announce/entity/announce.dart';
import 'package:mimir/school/oa_announce/page/detail.dart';
import 'package:mimir/school/ywb/page/index.dart';
import 'package:mimir/school/exam_arrange/page/index.dart';
import 'package:mimir/school/library/index.dart';
import 'package:mimir/school/oa_announce/page/index.dart';
import 'package:mimir/scanner/page/index.dart';
import 'package:mimir/school/class2nd/entity/list.dart';
import 'package:mimir/school/class2nd/page/detail.dart';
import 'package:mimir/school/class2nd/page/list.dart';
import 'package:mimir/school/class2nd/page/attended.dart';
import 'package:mimir/school/exam_result/page/evaluation.dart';
import 'package:mimir/school/exam_result/page/index.dart';
import 'package:mimir/school/yellow_pages/page/index.dart';
import 'package:mimir/settings/page/credential.dart';
import 'package:mimir/settings/page/developer.dart';
import 'package:mimir/settings/page/index.dart';
import 'package:mimir/me/index.dart';
import 'package:mimir/school/index.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/page/import.dart';
import 'package:mimir/timetable/page/index.dart';
import 'package:mimir/timetable/page/mine.dart';
import 'package:mimir/timetable/page/preview.dart';
import 'package:mimir/widgets/image.dart';
import 'package:mimir/widgets/webview/page.dart';

import 'app.dart';

bool isLoginGuarded(BuildContext ctx) {
  final auth = ctx.auth;
  return auth.loginStatus != LoginStatus.validated && auth.credential == null;
}

String? _loginRequired(BuildContext ctx, GoRouterState state) {
  if (isLoginGuarded(ctx)) return "/login?guard=true";
  return null;
}

final router = GoRouter(
  navigatorKey: $Key,
  initialLocation: "/",
  debugLogDiagnostics: kDebugMode,
  redirect: (ctx, state) {
    final auth = ctx.auth;
    if (auth.loginStatus == LoginStatus.never) {
      // allow to access settings page.
      if (state.matchedLocation == "/settings") return null;
      // allow to access browser page.
      if (state.matchedLocation == "/browser") return null;
      return "/login";
    }
    return null;
  },
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
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/timetable",
            // Timetable is the home page.
            builder: (ctx, state) => const TimetablePage(),
            routes: [
              GoRoute(
                path: "preview/:id",
                builder: (ctx, state) {
                  final extra = state.extra;
                  if (extra is SitTimetable) return TimetablePreviewPage(timetable: extra);
                  final timetable = TimetableInit.storage.getSitTimetableById(id: state.pathParameters["id"]);
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
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/school",
            builder: (ctx, state) => const SchoolPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/life",
            builder: (ctx, state) => const LifePage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/me",
            builder: (ctx, state) => const MePage(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: "/browser",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is String) {
          return WebViewPage(initialUrl: extra);
        }
        throw 404;
      },
    ),
    GoRoute(
      path: "/settings",
      builder: (ctx, state) => const SettingsPage(),
    ),
    GoRoute(
      path: "/network-tool",
      builder: (ctx, state) => const NetworkToolPage(),
    ),
    GoRoute(
      path: "/credential",
      builder: (ctx, state) => const CredentialPage(),
    ),
    GoRoute(
      path: "/developer-options",
      builder: (ctx, state) => const DeveloperOptionsPage(),
    ),
    GoRoute(
      path: "/class2nd/activity",
      builder: (ctx, state) => const ActivityListPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/class2nd/attended",
      builder: (ctx, state) => const AttendedActivityPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/class2nd/activity-detail",
      builder: (ctx, state) {
        final enableApply = state.uri.queryParameters["enable-apply"] != null;
        final extra = state.extra;
        if (extra is Class2ndActivity) {
          return Class2ndActivityDetailPage(
            extra,
            enableApply: enableApply,
          );
        }
        throw 404;
      },
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/expense-records",
      builder: (ctx, state) => const ExpenseRecordsPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/expense-records/statistics",
      builder: (ctx, state) => const ExpenseStatisticsPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/oa-announce",
      builder: (ctx, state) => const OaAnnouncePage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/oa-announce/details",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is AnnounceRecord) {
          return AnnounceDetailsPage(extra);
        }
        throw 404;
      },
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/yellow-pages",
      builder: (ctx, state) => const YellowPagesListPage(),
    ),
    GoRoute(
      path: "/edu-email",
      builder: (ctx, state) => const EduEmailPage(),
    ),
    GoRoute(
      path: "/exam-result",
      builder: (ctx, state) => const ExamResultPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/exam-arrange",
      builder: (ctx, state) => const ExamArrangementPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/library",
      builder: (ctx, state) => const LibraryPage(),
    ),
    GoRoute(
      path: "/timetable",
      builder: (ctx, state) => const TimetablePage(),
    ),
    GoRoute(
      path: "/application",
      builder: (ctx, state) => const ApplicationIndexPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/scanner",
      builder: (ctx, state) => const ScannerPage(),
    ),
    GoRoute(
      path: "/teacher-eval",
      builder: (ctx, state) => const EvaluationPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/login",
      builder: (ctx, state) {
        final guarded = state.uri.queryParameters["guard"] == "true";
        return LoginPage(isGuarded: guarded);
      },
    ),
    GoRoute(
      path: "/image/:title",
      builder: (ctx, state) {
        final extra = state.extra;
        if (extra is String?) {
          return ImageViewPage(
            extra,
            title: state.pathParameters["title"],
          );
        }
        throw 400;
      },
    ),
  ],
);
