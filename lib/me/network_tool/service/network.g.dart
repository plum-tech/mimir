// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusNetworkStatus _$CampusNetworkStatusFromJson(Map<String, dynamic> json) => CampusNetworkStatus(
      _toBool(json['result'] as int),
      json['v46ip'] as String,
      studentId: json['uid'] as String?,
    );

LogoutResult _$LogoutResultFromJson(Map<String, dynamic> json) => LogoutResult(
      json['result'] as int,
    );

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
      json['result'] as int,
    );

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) => <String, dynamic>{
      'result': instance.result,
    };
