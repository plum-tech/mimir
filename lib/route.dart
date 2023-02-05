import 'package:mimir/credential/symbol.dart';
import 'package:mimir/home/page/index.dart';
import 'package:mimir/navigation/static_route.dart';
import 'package:mimir/settings/page/index.dart';

import 'module/exam_result/page/evaluation.dart';
import 'module/simple_page/page/browser.dart';
import 'module/symbol.dart';

class RouteTable {
  RouteTable._();

  static const root = '/';
  static const home = '/home';
  static const activity = '/activity';
  static const application = '/application';
  static const networkTool = '/network_tool';
  static const eduEmail = '/edu_email';
  static const electricityBill = '/electricity_bill';
  static const reportTemp = '/report_temp';
  static const login = '/login';
  static const welcome = '/welcome';
  static const expense = '/expense';
  static const examResult = '/exam_result';
  static const examResultEvaluation = '/exam_result/evaluation';
  static const library = '/library';
  static const timetable = '/timetable';
  static const timetableImport = '$timetable/import';
  static const timetableMine = '$timetable/mine';
  static const settings = '/settings';
  static const yellowPages = '/yellow_pages';
  static const oaAnnouncement = '/oa_announcement';
  static const examArrangement = '/exam_arrangement';
  static const scanner = '/scanner';
  static const browser = '/browser';
  static const notFound = '/not_found';
  static const simpleHtml = '/simple_html';
  static const relogin = '/relogin';
}

final defaultRouteTable = StaticRouteTable(
  table: {
    RouteTable.home: (context, args) => const HomePage(),
    RouteTable.reportTemp: (context, args) => const DailyReportIndexPage(),
    RouteTable.login: (context, args) => args["disableOffline"] == true
        ? const LoginPage(
            disableOffline: true,
          )
        : const LoginPage(
            disableOffline: false,
          ),
    RouteTable.welcome: (context, args) => const WelcomePage(),
    RouteTable.expense: (context, args) => const ExpenseTrackerPage(),
    RouteTable.networkTool: (context, args) => const NetworkToolPage(),
    RouteTable.electricityBill: (context, args) => const ElectricityBillPage(),
    RouteTable.examResult: (context, args) => const ExamResultPage(),
    RouteTable.application: (context, args) => const ApplicationIndexPage(),
    RouteTable.library: (context, args) => const LibraryPage(),
    RouteTable.timetable: (context, args) => const TimetableIndexPage(),
    RouteTable.timetableImport: (context, args) => const ImportTimetableIndexPage(),
    RouteTable.timetableMine: (context, args) => const MyTimetablePage(),
    RouteTable.settings: (context, args) => const SettingsPage(),
    RouteTable.yellowPages: (context, args) => const YellowPagesPage(),
    RouteTable.oaAnnouncement: (context, args) => const OaAnnouncePage(),
    RouteTable.eduEmail: (context, args) => const MailPage(),
    RouteTable.activity: (context, args) => const ActivityIndexPage(),
    RouteTable.examArrangement: (context, args) => const ExamArrangementPage(),
    RouteTable.scanner: (context, args) => const ScannerPage(),
    RouteTable.browser: (context, args) {
      return BrowserPage(
        initialUrl: args['initialUrl'],
        fixedTitle: args['fixedTitle'],
        showSharedButton: args['showSharedButton'],
        showRefreshButton: args['showRefreshButton'],
        showLoadInBrowser: args['showLoadInBrowser'],
        userAgent: args['userAgent'],
        showLaunchButtonIfUnsupported: args['showLaunchButtonIfUnsupported'],
        showTopProgressIndicator: args['showTopProgressIndicator'],
        javascript: args['javascript'],
        javascriptUrl: args['javascriptUrl'],
      );
    },
    RouteTable.notFound: (context, args) => NotFoundPage(args['routeName']),
    RouteTable.simpleHtml: (context, args) {
      return SimpleHtmlPage(
        title: args['title'],
        url: args['url'],
        htmlContent: args['htmlContent'],
      );
    },
    RouteTable.relogin: (context, args) => const UnauthorizedTipPage(),
    RouteTable.examResultEvaluation: (context, args) => const EvaluationPage(),
  },
  onNotFound: (context, routeName, args) => NotFoundPage(routeName),
  rootRoute: (context, table, args) {
    // The freshmen and OA users who ever logged in can directly land on the homepage.
    // While, the offline users have to click the `Offline Mode` button every time.
    final routeName = Auth.lastOaAuthTime != null ? RouteTable.home : RouteTable.welcome;
    return table.onGenerateRoute(routeName, args)(context);
  },
);
