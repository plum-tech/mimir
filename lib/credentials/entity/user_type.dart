import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'user_type.g.dart';

@HiveType(typeId: CoreHiveType.oaUserType)
enum OaUserType {
  @HiveField(0)
  undergraduate(allowed: {
    AppFeature.mimirForum,
    AppFeature.mimirBulletin,
    AppFeature.timetable,
    AppFeature.secondClass$,
    AppFeature.examResultUg,
    AppFeature.examArrangement,
    AppFeature.teacherEval,
    AppFeature.ywb,
    AppFeature.gpaUg,
    AppFeature.yellowPages,
    AppFeature.expenseRecords$,
    AppFeature.electricityBalance,
    AppFeature.library$,
    AppFeature.eduEmail$,
    AppFeature.oaAnnouncement,
    AppFeature.game$,
    AppFeature.mimirUpdate,
  }),
  @HiveField(1)
  postgraduate(allowed: {
    AppFeature.mimirForum,
    AppFeature.mimirBulletin,
    AppFeature.timetable,
    AppFeature.examResultPg,
    AppFeature.ywb,
    AppFeature.expenseRecords$,
    AppFeature.electricityBalance,
    AppFeature.library$,
    AppFeature.yellowPages,
    AppFeature.eduEmail$,
    AppFeature.oaAnnouncement,
    AppFeature.game$,
    AppFeature.mimirUpdate,
  }),
  @HiveField(2)
  freshman(allowed: {
    AppFeature.mimirForum,
    AppFeature.mimirBulletin,
    AppFeature.yellowPages,
    AppFeature.librarySearch,
    AppFeature.oaAnnouncement,
    AppFeature.freshman,
    AppFeature.game$,
    AppFeature.mimirUpdate,
  }),
  @HiveField(3)
  worker(allowed: {
    AppFeature.mimirForum,
    AppFeature.mimirBulletin,
    AppFeature.ywb,
    AppFeature.expenseRecords$,
    AppFeature.electricityBalance,
    AppFeature.yellowPages,
    AppFeature.library$,
    AppFeature.oaAnnouncement,
    AppFeature.game$,
    AppFeature.mimirUpdate,
  }),
  @HiveField(4)
  none(allowed: {
    AppFeature.mimirForum,
    AppFeature.mimirBulletin,
    AppFeature.timetable,
    AppFeature.electricityBalance,
    AppFeature.librarySearch,
    AppFeature.eduEmail$,
    AppFeature.yellowPages,
    AppFeature.mimirUpdate,
  });

  final Set<String> allowed;

  const OaUserType({
    required this.allowed,
  });

  String l10n() => "OaUserType.$name".tr();

  static final _type2Filter = Map.fromEntries(OaUserType.values.map(
    (v) => MapEntry(v, AppFeatureFilter.build(allow: v.allowed, prohibit: {})),
  ));

  AppFeatureFilter get featureFilter => _type2Filter[this]!;
}
