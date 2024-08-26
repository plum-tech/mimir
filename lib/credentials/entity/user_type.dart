import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'user_type.g.dart';

typedef UserCapability = ({
  bool enableClass2nd,
  bool enableExamArrange,
  bool enableExamResult,
});

@HiveType(typeId: CoreHiveType.oaUserType)
enum OaUserType {
  @HiveField(0)
  undergraduate((
    enableClass2nd: true,
    enableExamArrange: true,
    enableExamResult: true,
  )),
  @HiveField(1)
  postgraduate((
    enableClass2nd: false,
    // postgraduates use a different SIS, so disable them temporarily
    enableExamArrange: false,
    enableExamResult: true,
  )),
  @HiveField(2)
  other((
    enableClass2nd: false,
    enableExamArrange: false,
    enableExamResult: false,
  ));

  final UserCapability capability;

  const OaUserType(this.capability);

  String l10n() => "OaUserType.$name".tr();
}
