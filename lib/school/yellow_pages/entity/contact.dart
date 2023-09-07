import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

part 'contact.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeId.schoolContact)
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

  SchoolContact(this.department, this.description, this.name, this.phone);

  factory SchoolContact.fromJson(Map<String, dynamic> json) => _$SchoolContactFromJson(json);

  @override
  String toString() {
    return '{department: $department, description: $description, name: $name, phone: $phone}';
  }
}
