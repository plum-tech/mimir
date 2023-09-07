// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolContact _$SchoolContactFromJson(Map<String, dynamic> json) => SchoolContact(
      json['department'] as String,
      json['description'] as String?,
      json['name'] as String?,
      json['phone'] as String,
    );

Map<String, dynamic> _$SchoolContactToJson(SchoolContact instance) {
  final val = <String, dynamic>{
    'department': instance.department,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('name', instance.name);
  val['phone'] = instance.phone;
  return val;
}
