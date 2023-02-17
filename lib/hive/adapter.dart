import 'package:mimir/credential/symbol.dart';
import 'package:mimir/main/desktop/entity/miniApp.dart';
import 'package:mimir/module/symbol.dart';

import 'adapter/color.dart';
import 'adapter/size.dart';
import 'adapter/version.dart';
import 'using.dart';
import 'package:mimir/entities.dart';

class HiveAdapter {
  HiveAdapter._();

  static final List<TypeAdapter> list = [
    CourseAdapter(),
    MiniAppAdapter(),
    BalanceAdapter(),
    LibrarySearchHistoryItemAdapter(),
    TimetableMetaLegacyAdapter(),
    VersionAdapter(),
    SizeAdapter(),
    ColorAdapter(),
    // Activity
    ActivityDetailAdapter(),
    ActivityAdapter(),
    ScScoreSummaryAdapter(),
    ScActivityApplicationAdapter(),
    ScScoreItemAdapter(),
    ActivityTypeAdapter(),
    // Exam Arrangement
    ExamEntryAdapter(),
    // OA Announcement
    AnnounceDetailAdapter(),
    AnnounceCatalogueAdapter(),
    AnnounceRecordAdapter(),
    AnnounceAttachmentAdapter(),
    AnnounceListPageAdapter(),
    // Application
    ApplicationDetailSectionAdapter(),
    ApplicationDetailAdapter(),
    ApplicationMetaAdapter(),
    ApplicationMsgCountAdapter(),
    ApplicationMsgAdapter(),
    ApplicationMsgPageAdapter(),
    ApplicationMessageTypeAdapter(),

    // Credential
    OACredentialAdapter(),
    UserTypeAdapter(),

    // Exam Result
    ExamResultAdapter(),
    ExamResultDetailAdapter(),

    SchoolYearAdapter(),
    SemesterAdapter(),
  ];

  static void registerAll() {
    for (final adapter in list) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }
  }
}
