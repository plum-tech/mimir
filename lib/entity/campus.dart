import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'campus.g.dart';

enum CampusFeature {
  electricity,
  ;
}

@HiveType(typeId: CoreHiveType.campus)
enum Campus {
  @HiveField(0)
  fengxian({
    CampusFeature.electricity,
  }),
  @HiveField(1)
  xuhui({
    CampusFeature.electricity,
  });

  final Set<CampusFeature> features;

  const Campus(this.features);

  String l10nName() => "campus.$name".tr();

  bool has(CampusFeature feature) {
    return features.contains(feature);
  }
}
