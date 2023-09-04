import 'package:mimir/hive/type_id.dart';

part 'login_status.g.dart';

@HiveType(typeId: HiveTypeId.loginStatus)
enum LoginStatus {
  @HiveField(0)
  never,
  @HiveField(2)
  offline,
  @HiveField(3)
  validated,
}
