import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'campus.g.dart';

@HiveType(typeId: CoreHiveType.campus)
enum Campus {
  @HiveField(0)
  fengxian(prohibited: {}),
  @HiveField(1)
  xuhui(prohibited: {
    "school.electricityBalance",
    "school.sitRobot",
  });

  final Set<String> prohibited;

  const Campus({
    required this.prohibited,
  });

  String l10n() => "campus.$name".tr();

  static final _type2Prohibited = Map.fromEntries(Campus.values.map(
    (v) => MapEntry(v, AppFeatureTree.build(v.prohibited)),
  ));

  bool prohibit(String feature) {
    final tree = _type2Prohibited[this];
    if (tree == null) return false;
    return tree.has(feature);
  }
}
