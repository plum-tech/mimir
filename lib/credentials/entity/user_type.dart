import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/storage/hive/type_id.dart';

part 'user_type.g.dart';

enum UserCapability {
  timetable,
  class2nd,
  examArrange,
  examResult,
  ywb,
  electricityBalance,
  expenseRecords,
  libraryAccount,
  eduEmail,
}

@HiveType(typeId: CoreHiveType.oaUserType)
enum OaUserType {
  @HiveField(0)
  undergraduate({
    UserCapability.timetable,
    UserCapability.class2nd,
    UserCapability.examArrange,
    UserCapability.examResult,
    UserCapability.ywb,
    UserCapability.electricityBalance,
    UserCapability.expenseRecords,
    UserCapability.libraryAccount,
    UserCapability.eduEmail,
  }),
  @HiveField(1)
  postgraduate({
    UserCapability.timetable,
    // postgraduates use a different SIS, so disable the exam arrangement
    UserCapability.examResult,
    UserCapability.ywb,
    UserCapability.electricityBalance,
    UserCapability.expenseRecords,
    UserCapability.libraryAccount,
    UserCapability.eduEmail,
  }),
  @HiveField(2)
  freshman({}),
  @HiveField(3)
  worker({
    UserCapability.ywb,
    UserCapability.libraryAccount,
    UserCapability.electricityBalance,
    UserCapability.expenseRecords,
    UserCapability.eduEmail,
  });

  final Set<UserCapability> capabilities;

  const OaUserType(this.capabilities);

  String l10n() => "OaUserType.$name".tr();

  bool has(UserCapability capability) {
    return capabilities.contains(capability);
  }
}
