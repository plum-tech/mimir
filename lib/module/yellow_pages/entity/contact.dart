import 'package:json_annotation/json_annotation.dart';

import '../using.dart';

part 'contact.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeId.contact)
class ContactData {
  ///部门
  @HiveField(0)
  final String department;

  ///说明
  @HiveField(1)
  final String? description;

  ///姓名
  @HiveField(2)
  final String? name;

  ///电话
  @HiveField(3)
  final String phone;

  ContactData(this.department, this.description, this.name, this.phone);

  factory ContactData.fromJson(Map<String, dynamic> json) => _$ContactDataFromJson(json);

  @override
  String toString() {
    return 'ContactData{department: $department, description: $description, name: $name, phone: $phone}';
  }
}
