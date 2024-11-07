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
  });

  final Set<String> prohibited;

  const Campus({
    required this.prohibited,
  });

  String l10n() => "campus.$name".tr();

  static final _type2Filter = Map.fromEntries(Campus.values.map(
    (v) => MapEntry(v, AppFeatureFilter.build(allow: {}, prohibit: v.prohibited)),
  ));

  AppFeatureFilter get featureFilter => _type2Filter[this]!;
}
