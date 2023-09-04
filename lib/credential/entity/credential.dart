import 'package:mimir/hive/type_id.dart';

part 'credential.g.dart';

@HiveType(typeId: HiveTypeId.credential)
class Credential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  Credential(this.account, this.password);

  @override
  String toString() => 'account:"$account", password:"$password"';

  Credential copyWith({
    String? account,
    String? password,
  }) =>
      Credential(
        account ?? this.account,
        password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is Credential &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
