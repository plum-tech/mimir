// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusNetworkStatus _$CampusNetworkStatusFromJson(Map<String, dynamic> json) => CampusNetworkStatus(
      loggedIn: _toBool((json['result'] as num).toInt()),
      ip: json['v46ip'] as String,
      studentId: json['uid'] as String?,
    );

LogoutResult _$LogoutResultFromJson(Map<String, dynamic> json) => LogoutResult(
      (json['result'] as num).toInt(),
    );

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
      (json['result'] as num).toInt(),
    );

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) => <String, dynamic>{
      'result': instance.result,
    };
