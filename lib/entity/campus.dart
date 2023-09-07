import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/hive/type_id.dart';

part 'campus.g.dart';

@HiveType(typeId: HiveTypeId.campus)
enum Campus {
  @HiveField(0)
  fengxian,
  @HiveField(1)
  xuhui;

  String l10nName() => "campus.$name".tr();
}
