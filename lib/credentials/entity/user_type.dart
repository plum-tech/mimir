import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'user_type.g.dart';

@HiveType(typeId: CoreHiveType.oaUserType)
enum OaUserType {
  @HiveField(0)
  undergraduate(allowed: {
    "mimir.forum",
    "mimir.bulletin",
    "basic.timetable",
    "school.secondClass",
    "school.examResult.ug",
    "school.examArrangement",
    "school.teacherEval",
    "school.ywb",
    "school.gpa",
    "school.yellowPages",
    "school.expenseRecords",
    "school.electricityBalance",
    "school.library",
    "school.eduEmail",
    "school.oaAnnouncement",
    "game",
  }),
  @HiveField(1)
  postgraduate(allowed: {
    "mimir.forum",
    "mimir.bulletin",
    "basic.timetable",
    "school.examResult.pg",
    "school.ywb",
    "school.expenseRecords",
    "school.electricityBalance",
    "school.library",
    "school.yellowPages",
    "school.eduEmail",
    "school.oaAnnouncement",
    "game",
  }),
  @HiveField(2)
  freshman(allowed: {
    "mimir.forum",
    "mimir.bulletin",
    "school.yellowPages",
    "school.library.search",
    "school.oaAnnouncement",
    "school.freshman",
    "game",
  }),
  @HiveField(3)
  worker(allowed: {
    "mimir.forum",
    "mimir.bulletin",
    "school.ywb",
    "school.expenseRecords",
    "school.electricityBalance",
    "school.yellowPages",
    "school.library",
    "school.oaAnnouncement",
    "game",
  }),
  @HiveField(4)
  none(allowed: {
    "mimir.forum",
    "mimir.bulletin",
    "basic.timetable",
    "school.electricityBalance",
    "school.library.search",
    "school.eduEmail",
    "school.yellowPages",
    "game",
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
