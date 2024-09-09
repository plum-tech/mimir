// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreshmanInfo _$FreshmanInfoFromJson(Map<String, dynamic> json) => FreshmanInfo(
      studentId: json['studentId'] as String,
      idNumber: json['idNumber'] as String,
      name: json['name'] as String,
      sex: json['sex'] as String,
      college: json['college'] as String,
      major: json['major'] as String,
      yearClass: json['yearClass'] as String,
      campus: $enumDecode(_$CampusEnumMap, json['campus']),
      buildingNumber: json['buildingNumber'] as String,
      roomNumber: json['roomNumber'] as String,
      bedNumber: json['bedNumber'] as String,
      advisorName: json['advisorName'] as String,
      advisorContact: json['advisorContact'] as String,
      advisorNote: json['advisorNote'] as String,
    );

Map<String, dynamic> _$FreshmanInfoToJson(FreshmanInfo instance) => <String, dynamic>{
      'studentId': instance.studentId,
      'idNumber': instance.idNumber,
      'name': instance.name,
      'sex': instance.sex,
      'college': instance.college,
      'major': instance.major,
      'yearClass': instance.yearClass,
      'campus': _$CampusEnumMap[instance.campus]!,
      'buildingNumber': instance.buildingNumber,
      'roomNumber': instance.roomNumber,
      'bedNumber': instance.bedNumber,
      'advisorName': instance.advisorName,
      'advisorContact': instance.advisorContact,
      'advisorNote': instance.advisorNote,
    };

const _$CampusEnumMap = {
  Campus.fengxian: 'fengxian',
  Campus.xuhui: 'xuhui',
};
