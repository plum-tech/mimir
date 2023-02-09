import 'package:flutter/material.dart';
import 'package:mimir/home/magic_brick/report.dart';
import 'package:universal_platform/universal_platform.dart';

import '../launcher.dart';
import '../route.dart';
import '../util/logger.dart';
import '../util/scanner.dart';
import 'entity/home.dart';
import 'magic_brick/application.dart';
import 'magic_brick/electricity.dart';
import 'magic_brick/exam.dart';
import 'magic_brick/expense.dart';
import 'magic_brick/library.dart';
import 'magic_brick/mail.dart';
import 'user_widget/brick.dart';

class HomepageFactory {
  static final Map<FType, WidgetBuilder?> builders = {
    FType.reportTemp: (context) => const ReportTempItem(),
    FType.timetable: (context) => Brick(
          route: RouteTable.timetable,
          icon: SvgAssetIcon('assets/home/icon_timetable.svg'),
          title: FType.timetable.localized(),
          subtitle: FType.timetable.localizedDesc(),
        ),
    FType.examArr: (context) => const ExamArrangementItem(),
    FType.activity: (context) => Brick(
          route: RouteTable.activity,
          icon: SvgAssetIcon('assets/home/icon_event.svg'),
          title: FType.activity.localized(),
          subtitle: FType.activity.localizedDesc(),
        ),
    FType.expense: (context) => const ExpenseItem(),
    FType.examResult: (context) => Brick(
          route: RouteTable.examResult,
          icon: SvgAssetIcon('assets/home/icon_score.svg'),
          title: FType.examResult.localized(),
          subtitle: FType.examResult.localizedDesc(),
        ),
    FType.library: (context) => const LibraryItem(),
    FType.application: (context) => const ApplicationItem(),
    FType.eduEmail: (context) => const EduEmailItem(),
    FType.oaAnnouncement: (context) => Brick(
          route: RouteTable.oaAnnouncement,
          icon: SvgAssetIcon('assets/home/icon_bulletin.svg'),
          title: FType.oaAnnouncement.localized(),
          subtitle: FType.oaAnnouncement.localizedDesc(),
        ),
    FType.yellowPages: (context) => Brick(
          route: RouteTable.yellowPages,
          icon: SvgAssetIcon('assets/home/icon_contact.svg'),
          title: FType.yellowPages.localized(),
          subtitle: FType.yellowPages.localizedDesc(),
        ),
    FType.separator: (context) => Container(),
    FType.scanner: UniversalPlatform.isDesktopOrWeb
        ? null
        : (context) => Brick(
              onPressed: () async {
                final result = await scan(context);
                Log.info('扫码结果: $result');
                if (result != null) GlobalLauncher.launch(result);
              },
              icon: SysIcon(Icons.qr_code_scanner),
              title: FType.scanner.localized(),
              subtitle: FType.scanner.localizedDesc(),
            ),
    FType.electricityBill: (context) => const ElectricityBillItem(),
  };

  static Widget? buildBrickWidget(BuildContext context, FType type) {
    if (!builders.containsKey(type)) {
      throw UnimplementedError("Brick[${type.name}] is not available.");
    }
    final builder = builders[type];
    return builder?.call(context);
  }
}
