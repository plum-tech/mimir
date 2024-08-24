// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulletin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MimirBulletin _$MimirBulletinFromJson(Map<String, dynamic> json) => MimirBulletin(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      content: json['content'] as String,
    );
