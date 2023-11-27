import 'package:sit/storage/hive/type_id.dart';

part 'credential.g.dart';

@HiveType(typeId: CoreHiveType.credentials)
class Credentials {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  Credentials({
    required this.account,
    required this.password,
  });

  @override
  String toString() => 'account:"$account", password:"$password"';

  Credentials copyWith({
    String? account,
    String? password,
  }) =>
      Credentials(
        account: account ?? this.account,
        password: password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is Credentials &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
