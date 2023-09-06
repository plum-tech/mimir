import 'package:mimir/credential/symbol.dart';
import 'package:mimir/life/elec_balance/entity/account.dart';
import 'package:mimir/mini_apps/activity/entity/detail.dart';
import 'package:mimir/mini_apps/activity/entity/list.dart';
import 'package:mimir/mini_apps/activity/entity/score.dart';
import 'package:mimir/mini_apps/application/entity/application.dart';
import 'package:mimir/mini_apps/application/entity/message.dart';
import 'package:mimir/mini_apps/exam_arr/entity/exam.dart';
import 'package:mimir/mini_apps/exam_result/entity/result.dart';
import 'package:mimir/mini_apps/oa_announce/entity/announce.dart';
import 'package:mimir/mini_apps/oa_announce/entity/attachment.dart';
import 'package:mimir/mini_apps/symbol.dart';

import 'custom_adapters.dart';
import 'using.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerAll() {
    // Basic
    ~VersionAdapter();
    ~ThemeModeAdapter();

    // Credential
    ~OaCredentialAdapter();
    ~EmailCredentialAdapter();
    ~LoginStatusAdapter();

    // Electric Bill
    ~BalanceAdapter();

    // Activity
    ~ActivityDetailAdapter();
    ~ActivityAdapter();
    ~ScScoreSummaryAdapter();
    ~ScActivityApplicationAdapter();
    ~ScScoreItemAdapter();
    ~ActivityTypeAdapter();

    // Exam Arrangement
    ~ExamEntryAdapter();

    // OA Announcement
    ~AnnounceDetailAdapter();
    ~AnnounceCatalogueAdapter();
    ~AnnounceRecordAdapter();
    ~AnnounceAttachmentAdapter();
    ~AnnounceListPageAdapter();

    // Application
    ~ApplicationDetailSectionAdapter();
    ~ApplicationDetailAdapter();
    ~ApplicationMetaAdapter();
    ~ApplicationMsgCountAdapter();
    ~ApplicationMsgAdapter();
    ~ApplicationMsgPageAdapter();
    ~ApplicationMessageTypeAdapter();

    // Exam Result
    ~ExamResultAdapter();
    ~ExamResultDetailAdapter();
    ~SchoolYearAdapter();
    ~SemesterAdapter();

    // Library
    ~LibrarySearchHistoryItemAdapter();
  }
}

extension _TypeAdapterEx<T> on TypeAdapter<T> {
  void operator ~() {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(this);
    }
  }
}
