import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class SchoolContact {
  @JsonKey()
  final String department;

  @JsonKey(includeIfNull: false)
  final String? description;

  @JsonKey(includeIfNull: false)
  final String? name;

  @JsonKey()
  final String phone;

  SchoolContact(this.department, this.description, this.name, this.phone);

  factory SchoolContact.fromJson(Map<String, dynamic> json) => _$SchoolContactFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolContactToJson(this);

  @override
  String toString() {
    return 'ContactData{department: $department, description: $description, name: $name, phone: $phone}';
  }
}
