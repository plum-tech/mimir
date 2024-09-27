import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable(createToJson: false)
class SchoolDeptContact {
  @JsonKey(name: "dept")
  final String department;
  final List<SchoolContact> contacts;

  const SchoolDeptContact({
    required this.department,
    required this.contacts,
  });

  factory SchoolDeptContact.fromJson(Map<String, dynamic> json) => _$SchoolDeptContactFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolDeptContact &&
          runtimeType == other.runtimeType &&
          department == other.department &&
          contacts.equals(other.contacts);

  @override
  int get hashCode => Object.hash(
        department,
        Object.hashAll(contacts),
      );
}

@JsonSerializable()
class SchoolContact {
  @JsonKey(name: "dept")
  final String department;

  @JsonKey(name: "desc", includeIfNull: false)
  final String? description;

  @JsonKey(includeIfNull: false)
  final String? name;

  @JsonKey()
  final String phone;

  const SchoolContact({
    required this.department,
    required this.description,
    required this.name,
    required this.phone,
  });

  factory SchoolContact.fromJson(Map<String, dynamic> json) => _$SchoolContactFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolContactToJson(this);

  @override
  String toString() {
    return '[$department] $description + $name $phone';
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
  int get hashCode => Object.hash(
        department,
        name,
        phone,
        description,
      );
}
