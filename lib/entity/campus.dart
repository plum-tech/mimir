import 'package:easy_localization/easy_localization.dart';
import 'package:sit/storage/hive/type_id.dart';

part 'campus.g.dart';

typedef CampusCapability = ({bool enableElectricity});

@HiveType(typeId: CoreHiveType.campus)
enum Campus {
  @HiveField(0)
  fengxian((enableElectricity: true)),
  @HiveField(1)
  xuhui((enableElectricity: false));

  final CampusCapability capability;

  const Campus(this.capability);

  String l10nName() => "campus.$name".tr();
}
