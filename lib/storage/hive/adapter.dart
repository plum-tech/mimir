import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/life/electricity/entity/balance.dart';
import 'package:sit/life/expense_records/entity/local.dart';
import 'package:sit/school/class2nd/entity/application.dart';
import 'package:sit/school/exam_result/entity/result.pg.dart';
import 'package:sit/school/library/entity/book.dart';
import 'package:sit/school/library/entity/borrow.dart';
import 'package:sit/school/library/entity/image.dart';
import 'package:sit/school/ywb/entity/service.dart';
import 'package:sit/school/ywb/entity/application.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import 'package:sit/school/oa_announce/entity/announce.dart';
import 'package:sit/school/class2nd/entity/details.dart';
import 'package:sit/school/class2nd/entity/activity.dart';
import 'package:sit/school/class2nd/entity/attended.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:sit/settings/entity/proxy.dart';
import 'package:sit/storage/hive/init.dart';

import 'builtin.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerCoreAdapters(HiveInterface hive) {
    debugPrint("Register core Hive type");
    // Basic
    hive.addAdapter(SizeAdapter());
    hive.addAdapter(VersionAdapter());
    hive.addAdapter(ThemeModeAdapter());
    hive.addAdapter(CampusAdapter());

    // Credential
    hive.addAdapter(CredentialsAdapter());
    hive.addAdapter(LoginStatusAdapter());
    hive.addAdapter(OaUserTypeAdapter());

    // Settings
    hive.addAdapter(ProxyModeAdapter());
  }

  static void registerCacheAdapters(HiveInterface hive) {
    debugPrint("Register cache Hive type");
    // Electric Bill
    hive.addAdapter(ElectricityBalanceAdapter());

    // Activity
    hive.addAdapter(Class2ndActivityDetailsAdapter());
    hive.addAdapter(Class2ndActivityAdapter());
    hive.addAdapter(Class2ndPointsSummaryAdapter());
    hive.addAdapter(Class2ndActivityApplicationAdapter());
    hive.addAdapter(Class2ndActivityApplicationStatusAdapter());
    hive.addAdapter(Class2ndPointItemAdapter());
    hive.addAdapter(Class2ndActivityCatAdapter());
    hive.addAdapter(Class2ndPointTypeAdapter());

    // OA Announcement
    hive.addAdapter(OaAnnounceDetailsAdapter());
    hive.addAdapter(OaAnnounceRecordAdapter());
    hive.addAdapter(OaAnnounceAttachmentAdapter());

    // Application
    hive.addAdapter(YwbServiceDetailSectionAdapter());
    hive.addAdapter(YwbServiceDetailsAdapter());
    hive.addAdapter(YwbServiceAdapter());
    hive.addAdapter(YwbApplicationAdapter());
    hive.addAdapter(YwbApplicationTrackAdapter());

    // Exam Result
    hive.addAdapter(ExamResultUgAdapter());
    hive.addAdapter(ExamResultItemAdapter());
    hive.addAdapter(UgExamTypeAdapter());
    hive.addAdapter(ExamResultPgAdapter());

    // Expense Records
    hive.addAdapter(TransactionAdapter());
    hive.addAdapter(TransactionTypeAdapter());

    // Yellow Pages
    hive.addAdapter(SchoolContactAdapter());

    // Library
    hive.addAdapter(BookAdapter());
    hive.addAdapter(BookDetailsAdapter());
    hive.addAdapter(BorrowedBookItemAdapter());
    hive.addAdapter(BookBorrowingHistoryItemAdapter());
    hive.addAdapter(BookBorrowingHistoryOperationAdapter());
    hive.addAdapter(BookImageAdapter());

    // School
    hive.addAdapter(SemesterAdapter());
    hive.addAdapter(SemesterInfoAdapter());
    hive.addAdapter(CourseCatAdapter());
  }
}
