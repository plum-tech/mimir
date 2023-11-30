// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookImage _$BookImageFromJson(Map<String, dynamic> json) => BookImage(
      json['isbn'] as String,
      json['coverlink'] as String,
      json['resourceLink'] as String,
      json['status'] as int,
    );

Map<String, dynamic> _$BookImageToJson(BookImage instance) => <String, dynamic>{
      'isbn': instance.isbn,
      'coverlink': instance.coverLink,
      'resourceLink': instance.resourceLink,
      'status': instance.status,
    };
