import 'package:hive/hive.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/life/electricity/entity/balance.dart';
import 'package:sit/life/expense_records/entity/local.dart';
import 'package:sit/school/library/entity/book.dart';
import 'package:sit/school/library/entity/borrow.dart';
import 'package:sit/school/ywb/entity/service.dart';
import 'package:sit/school/ywb/entity/application.dart';
import 'package:sit/school/exam_result/entity/result.dart';
import 'package:sit/school/oa_announce/entity/announce.dart';
import 'package:sit/school/class2nd/entity/details.dart';
import 'package:sit/school/class2nd/entity/list.dart';
import 'package:sit/school/class2nd/entity/attended.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:sit/storage/hive/init.dart';

import 'builtin.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerCoreAdapters(HiveInterface hive) {
    // Basic
    hive.addAdapter(SizeAdapter());
    hive.addAdapter(VersionAdapter());
    hive.addAdapter(ThemeModeAdapter());
    hive.addAdapter(CampusAdapter());

    // Credential
    hive.addAdapter(CredentialsAdapter());
    hive.addAdapter(LoginStatusAdapter());
    hive.addAdapter(OaUserTypeAdapter());

    // School
    hive.addAdapter(SemesterAdapter());
  }

  static void registerCacheAdapters(HiveInterface hive) {
    // Electric Bill
    hive.addAdapter(ElectricityBalanceAdapter());

    // Activity
    hive.addAdapter(Class2ndActivityDetailsAdapter());
    hive.addAdapter(Class2ndActivityAdapter());
    hive.addAdapter(Class2ndScoreSummaryAdapter());
    hive.addAdapter(Class2ndActivityApplicationAdapter());
    hive.addAdapter(Class2ndScoreItemAdapter());
    hive.addAdapter(Class2ndActivityCatAdapter());
    hive.addAdapter(Class2ndScoreTypeAdapter());

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
    hive.addAdapter(ExamResultAdapter());
    hive.addAdapter(ExamResultItemAdapter());

    // Library
    // ~LibrarySearchHistoryItemAdapter();

    // Expense Records
    hive.addAdapter(TransactionAdapter());
    hive.addAdapter(TransactionTypeAdapter());

    // Yellow Pages
    hive.addAdapter(SchoolContactAdapter());

    // Library
    hive.addAdapter(BookAdapter());
    hive.addAdapter(BookDetailsAdapter());
    hive.addAdapter(BorrowedBookItemAdapter());
    hive.addAdapter(BookBorrowHistoryItemAdapter());
  }
}
