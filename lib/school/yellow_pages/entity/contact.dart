import 'package:json_annotation/json_annotation.dart';
import 'package:sit/storage/hive/type_id.dart';
import 'package:quiver/core.dart';

part 'contact.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeSchool.schoolContact)
class SchoolContact {
  @JsonKey()
  @HiveField(0)
  final String department;

  @JsonKey(includeIfNull: false)
  @HiveField(1)
  final String? description;

  @JsonKey(includeIfNull: false)
  @HiveField(2)
  final String? name;

  @JsonKey()
  @HiveField(3)
  final String phone;

  const SchoolContact(this.department, this.description, this.name, this.phone);

  factory SchoolContact.fromJson(Map<String, dynamic> json) => _$SchoolContactFromJson(json);

  @override
  String toString() {
    return '{department: $department, description: $description, name: $name, phone: $phone}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolContact &&
          runtimeType == other.runtimeType &&
          department == other.department &&
          name == other.name &&
          phone == other.phone &&
          description == other.description;

  @override
  int get hashCode => hash4(department, name, phone, description);
}
