import 'package:mimir/hive/type_id.dart';

part 'credential.g.dart';

@HiveType(typeId: HiveTypeCredential.oa)
class OaCredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  OaCredential({
    required this.account,
    required this.password,
  });

  @override
  String toString() => 'account:"$account", password:"$password"';

  OaCredential copyWith({
    String? account,
    String? password,
  }) =>
      OaCredential(
        account: account ?? this.account,
        password: password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is OaCredential &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
