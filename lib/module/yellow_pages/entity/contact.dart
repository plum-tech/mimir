import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class ContactData {
  @JsonKey()
  final String department;

  @JsonKey(includeIfNull: false)
  final String? description;

  @JsonKey(includeIfNull: false)
  final String? name;

  @JsonKey()
  final String phone;

  ContactData(this.department, this.description, this.name, this.phone);

  factory ContactData.fromJson(Map<String, dynamic> json) => _$ContactDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDataToJson(this);

  @override
  String toString() {
    return 'ContactData{department: $department, description: $description, name: $name, phone: $phone}';
  }
}
