// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactData _$ContactDataFromJson(Map<String, dynamic> json) => ContactData(
      json['department'] as String,
      json['description'] as String?,
      json['name'] as String?,
      json['phone'] as String,
    );

Map<String, dynamic> _$ContactDataToJson(ContactData instance) {
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
