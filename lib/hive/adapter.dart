import 'package:mimir/credential/symbol.dart';
import 'package:mimir/mini_apps/symbol.dart';

import 'adapter/version.dart';
import 'using.dart';
import 'package:mimir/entities.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerAll() {
    // Basic
    ~VersionAdapter();

    // Credential
    ~CredentialAdapter();
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
