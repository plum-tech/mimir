import 'package:mimir/hive/type_id.dart';

part 'credential.g.dart';

@HiveType(typeId: HiveTypeCredentials.oa)
class OaCredentials {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  OaCredentials({
    required this.account,
    required this.password,
  });

  @override
  String toString() => 'account:"$account", password:"$password"';

  OaCredentials copyWith({
    String? account,
    String? password,
  }) =>
      OaCredentials(
        account: account ?? this.account,
        password: password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is OaCredentials &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
