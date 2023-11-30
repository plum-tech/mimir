// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookImage _$BookImageFromJson(Map<String, dynamic> json) => BookImage(
      isbn: json['isbn'] as String,
      coverLink: json['coverlink'] as String,
      resourceLink: json['resourceLink'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$BookImageToJson(BookImage instance) => <String, dynamic>{
      'isbn': instance.isbn,
      'coverlink': instance.coverLink,
      'resourceLink': instance.resourceLink,
      'status': instance.status,
    };
