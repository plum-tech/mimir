// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckStatusResult _$CheckStatusResultFromJson(Map<String, dynamic> json) => CheckStatusResult(
      json['result'] as int,
      json['v46ip'] as String,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$CheckStatusResultToJson(CheckStatusResult instance) => <String, dynamic>{
      'result': instance.result,
      'v46ip': instance.ip,
      'uid': instance.uid,
    };

LogoutResult _$LogoutResultFromJson(Map<String, dynamic> json) => LogoutResult(
      json['result'] as int,
    );

Map<String, dynamic> _$LogoutResultToJson(LogoutResult instance) => <String, dynamic>{
      'result': instance.result,
    };

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
      json['result'] as int,
    );

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) => <String, dynamic>{
      'result': instance.result,
    };
