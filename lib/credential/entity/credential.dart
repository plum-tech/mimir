import '../using.dart';

part 'credential.g.dart';

@HiveType(typeId: HiveTypeId.oaUserCredential)
class OACredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  OACredential(this.account, this.password);

  @override
  String toString() => 'account:"$account", password:"$password"';

  OACredential copyWith({
    String? account,
    String? password,
  }) =>
      OACredential(
        account ?? this.account,
        password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is OACredential &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
