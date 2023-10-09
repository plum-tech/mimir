import 'package:sit/hive/type_id.dart';

part 'email.g.dart';

@HiveType(typeId: HiveTypeCredentials.email)
class EmailCredentials {
  @HiveField(0)
  final String address;
  @HiveField(1)
  final String password;

  EmailCredentials({
    required this.address,
    required this.password,
  });

  @override
  String toString() => 'address:"$address", password:"$password"';

  EmailCredentials copyWith({
    String? address,
    String? password,
  }) =>
      EmailCredentials(
        address: address ?? this.address,
        password: password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is EmailCredentials &&
        runtimeType == other.runtimeType &&
        address == other.address &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
