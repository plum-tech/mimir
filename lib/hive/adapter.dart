import 'package:hive/hive.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/entity/email.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/life/electricity/entity/balance.dart';
import 'package:mimir/life/expense_records/entity/local.dart';
import 'package:mimir/school/ywb/entity/application.dart';
import 'package:mimir/school/ywb/entity/message.dart';
import 'package:mimir/school/exam_arrange/entity/exam.dart';
import 'package:mimir/school/oa_announce/entity/page.dart';
import 'package:mimir/school/exam_result/entity/result.dart';
import 'package:mimir/school/oa_announce/entity/announce.dart';
import 'package:mimir/school/class2nd/entity/details.dart';
import 'package:mimir/school/class2nd/entity/list.dart';
import 'package:mimir/school/class2nd/entity/score.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/school/yellow_pages/entity/contact.dart';

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

    // Exam Arrangement
    ~ExamEntryAdapter();

    // OA Announcement
    ~OaAnnounceDetailsAdapter();
    ~OaAnnounceCatalogueAdapter();
    ~OaAnnounceRecordAdapter();
    ~OaAnnounceAttachmentAdapter();
    ~OaAnnounceListPayloadAdapter();

    // Application
    ~YwbApplicationMetaDetailSectionAdapter();
    ~YwbApplicationMetaDetailsAdapter();
    ~YwbApplicationMetaAdapter();
    ~YwbApplicationAdapter();

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
