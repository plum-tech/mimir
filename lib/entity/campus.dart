import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/hive/type_id.dart';

part 'campus.g.dart';

typedef CampusCapability = ({bool enableElectricity});

@HiveType(typeId: HiveTypeId.campus)
enum Campus {
  @HiveField(0)
  fengxian((enableElectricity: true)),
  @HiveField(1)
  xuhui((enableElectricity: true));

  final CampusCapability capability;

  const Campus(this.capability);

  String l10nName() => "campus.$name".tr();
}
