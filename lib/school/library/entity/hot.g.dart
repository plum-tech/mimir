// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotSearchItem _$HotSearchItemFromJson(Map<String, dynamic> json) => HotSearchItem(
      keyword: json['keyword'] as String,
      count: json['count'] as int,
    );

Map<String, dynamic> _$HotSearchItemToJson(HotSearchItem instance) => <String, dynamic>{
      'keyword': instance.keyword,
      'count': instance.count,
    };

HotSearch _$HotSearchFromJson(Map<String, dynamic> json) => HotSearch(
      recent30days: (json['recent30days'] as List<dynamic>)
          .map((e) => HotSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as List<dynamic>).map((e) => HotSearchItem.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$HotSearchToJson(HotSearch instance) => <String, dynamic>{
      'recent30days': instance.recent30days,
      'total': instance.total,
    };
