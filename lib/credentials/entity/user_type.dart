import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'user_type.g.dart';

@HiveType(typeId: CoreHiveType.oaUserType)
enum OaUserType {
  @HiveField(0)
  undergraduate(allowed: {
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
    "school.yellowPages",
    "school.library.search",
    "school.oaAnnouncement",
    "school.freshman",
    "game",
  }),
  @HiveField(3)
  worker(allowed: {
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

  static final _type2Allowed = Map.fromEntries(OaUserType.values.map(
    (v) => MapEntry(v, AppFeatureTree.build(v.allowed)),
  ));

  bool allow(String feature) {
    final tree = _type2Allowed[this];
    if (tree == null) return false;
    return tree.has(feature);
  }
}
