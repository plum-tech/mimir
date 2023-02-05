import 'package:dio/dio.dart';
import 'package:mimir/session/report_session.dart';

import 'dao/report.dart';
import 'service/report.dart';
import 'using.dart';

class ReportTempInit {
  static late ISession session;
  static late ReportDao reportService;

  static void init({
    required Dio dio,
  }) {
    session = ReportSession(
      dio: dio,
    );
    reportService = ReportService(session);
  }
}
