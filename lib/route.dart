import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credential/entity/login_status.dart';
import 'package:sit/credential/widgets/oa_scope.dart';
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
import 'package:sit/main/index.dart';
import 'package:sit/me/edu_email/page/inbox.dart';
import 'package:sit/me/network_tool/page/index.dart';
import 'package:sit/page/not_found.dart';
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
import 'package:sit/settings/page/credential.dart';
import 'package:sit/settings/page/developer.dart';
import 'package:sit/settings/page/index.dart';
import 'package:sit/me/index.dart';
import 'package:sit/school/index.dart';
import 'package:sit/settings/page/timetable.dart';
import 'package:sit/timetable/entity/timetable.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/page/export.dart';
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

final router = GoRouter(
  navigatorKey: $Key,
  initialLocation: "/",
  debugLogDiagnostics: kDebugMode,
  errorBuilder: (ctx, state) => NotFoundPage(state.uri.toString()),
  redirect: (ctx, state) {
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
        StatefulShellBranch(
          navigatorKey: $TimetableShellKey,
          routes: [
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
                    final id = int.tryParse(state.pathParameters["id"] ?? "");
                    if (id == null) throw 404;
                    final timetable = TimetableInit.storage.timetable.getOf(id);
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
                  builder: (ctx, state) => const TimetableP13nPage(),
                ),
                GoRoute(
                  path: "calendar-export/:id",
                  builder: (ctx, state) {
                    final extra = state.extra;
                    if (extra is SitTimetable) return TimetableCalendarExportConfigPage(timetable: extra);
                    final id = int.tryParse(state.pathParameters["id"] ?? "");
                    if (id == null) throw 404;
                    final timetable = TimetableInit.storage.timetable.getOf(id);
                    if (timetable == null) throw 404;
                    return TimetableCalendarExportConfigPage(timetable: timetable);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: $SchoolShellKey,
          routes: [
            GoRoute(
              path: "/school",
              builder: (ctx, state) => const SchoolPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: $LifeShellKey,
          routes: [
            GoRoute(
              path: "/life",
              builder: (ctx, state) => const LifePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: $MeShellKey,
          routes: [
            GoRoute(
              path: "/me",
              builder: (ctx, state) => const MePage(),
            ),
          ],
        ),
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
    ),
    GoRoute(
      path: "/tools/network-tool",
      builder: (ctx, state) => const NetworkToolPage(),
    ),
    GoRoute(
      path: "/tools/scanner",
      parentNavigatorKey: $Key,
      builder: (ctx, state) => const ScannerPage(),
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
        // TODO: Fix restoration issues
        if (extra is Class2ndActivity) {
          return Class2ndActivityDetailsPage(
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
        ]),
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
    GoRoute(
      path: "/exam-result",
      builder: (ctx, state) => const ExamResultPage(),
      redirect: _loginRequired,
    ),
    GoRoute(
      path: "/exam-arrange",
      builder: (ctx, state) => const ExamArrangePage(),
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
      path: "/ywb",
      builder: (ctx, state) => const YwbApplicationMetaListPage(),
      redirect: _loginRequired,
      routes: [
        GoRoute(
          path: "mine",
          builder: (ctx, state) => const YwbMyApplicationListPage(),
        ),
      ],
    ),
    GoRoute(
      path: "/teacher-eval",
      builder: (ctx, state) => const TeacherEvaluationPage(),
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
    ),
  ],
);
