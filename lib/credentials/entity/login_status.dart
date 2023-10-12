import 'package:sit/hive/type_id.dart';

part 'login_status.g.dart';

@HiveType(typeId: HiveTypeCredentials.loginStatus)
enum LoginStatus {
  @HiveField(0)
  never,
  @HiveField(2)
  offline,
  @HiveField(3)
  validated,
  @HiveField(4)
  everLogin,
}
