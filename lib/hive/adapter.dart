import 'package:hive/hive.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/email.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/life/electricity/entity/balance.dart';
import 'package:sit/life/expense_records/entity/local.dart';
import 'package:sit/school/ywb/entity/meta.dart';
import 'package:sit/school/ywb/entity/application.dart';
import 'package:sit/school/exam_arrange/entity/exam.dart';
import 'package:sit/school/exam_result/entity/result.dart';
import 'package:sit/school/oa_announce/entity/announce.dart';
import 'package:sit/school/class2nd/entity/details.dart';
import 'package:sit/school/class2nd/entity/list.dart';
import 'package:sit/school/class2nd/entity/attended.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';

import 'builtins.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerAll() {
    // Basic
    ~SizeAdapter();
    ~VersionAdapter();
    ~ThemeModeAdapter();
    ~CampusAdapter();

    // Credential
    ~OaCredentialsAdapter();
    ~EmailCredentialsAdapter();
    ~LoginStatusAdapter();
    ~OaUserTypeAdapter();

    // Electric Bill
    ~ElectricityBalanceAdapter();

    // Activity
    ~Class2ndActivityDetailsAdapter();
    ~Class2ndActivityAdapter();
    ~Class2ndScoreSummaryAdapter();
    ~Class2ndActivityApplicationAdapter();
    ~Class2ndScoreItemAdapter();
    ~Class2ndActivityCatAdapter();
    ~Class2ndAttendedActivityAdapter();
    ~Class2ndActivityScoreTypeAdapter();

    // Exam Arrangement
    ~ExamEntryAdapter();

    // OA Announcement
    ~OaAnnounceDetailsAdapter();
    ~OaAnnounceCatalogueAdapter();
    ~OaAnnounceRecordAdapter();
    ~OaAnnounceAttachmentAdapter();

    // Application
    ~YwbApplicationMetaDetailSectionAdapter();
    ~YwbApplicationMetaDetailsAdapter();
    ~YwbApplicationMetaAdapter();
    ~YwbApplicationAdapter();
    ~YwbApplicationTrackAdapter();

    // Exam Result
    ~ExamResultAdapter();
    ~ExamResultItemAdapter();
    ~SemesterAdapter();

    // Library
    // ~LibrarySearchHistoryItemAdapter();

    // Expense Records
    ~TransactionAdapter();
    ~TransactionTypeAdapter();

    // Yellow Pages
    ~SchoolContactAdapter();
  }
}

extension _TypeAdapterEx<T> on TypeAdapter<T> {
  void operator ~() {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(this);
    }
  }
}
