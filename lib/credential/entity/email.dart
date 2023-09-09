import 'package:mimir/hive/type_id.dart';

part 'email.g.dart';

@HiveType(typeId: HiveTypeCredential.email)
class EmailCredential {
  @HiveField(0)
  final String address;
  @HiveField(1)
  final String password;

  EmailCredential({
    required this.address,
    required this.password,
  });

  @override
  String toString() => 'address:"$address", password:"$password"';

  EmailCredential copyWith({
    String? address,
    String? password,
  }) =>
      EmailCredential(
        address: address ?? this.address,
        password: password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is EmailCredential &&
        runtimeType == other.runtimeType &&
        address == other.address &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
