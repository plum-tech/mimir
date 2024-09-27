// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolDeptContact _$SchoolDeptContactFromJson(Map<String, dynamic> json) => SchoolDeptContact(
      department: json['dept'] as String,
      contacts:
          (json['contacts'] as List<dynamic>).map((e) => SchoolContact.fromJson(e as Map<String, dynamic>)).toList(),
    );

SchoolContact _$SchoolContactFromJson(Map<String, dynamic> json) => SchoolContact(
      department: json['dept'] as String,
      description: json['desc'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$SchoolContactToJson(SchoolContact instance) {
  final val = <String, dynamic>{
    'dept': instance.department,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('desc', instance.description);
  writeNotNull('name', instance.name);
  val['phone'] = instance.phone;
  return val;
}
